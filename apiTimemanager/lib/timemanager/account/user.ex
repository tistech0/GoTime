defmodule Timemanager.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true, redact: true)
    field(:hashed_password, :string, redact: true)
    field(:time_contract, :float)
    field(:username, :string)
    belongs_to(:role, Timemanager.Roles.Role, foreign_key: :role_id, type: :binary_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :time_contract, :role_id])
    |> validate_required([:username, :email, :password, :time_contract, :role_id])
  end

  @doc false
  def get_user!(id) do
    Timemanager.Repo.get!(Timemanager.Account.User, id)
  end

  @doc """
  Changeset specific for seed purposes
  """
  def seeds_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :hashed_password, :time_contract, :role_id])
    |> validate_required([:username, :email, :hashed_password, :time_contract, :role_id])
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:username, :email, :password, :time_contract, :role_id])
    |> validate_required([:username, :email, :password, :time_contract, :role_id])
    |> validate_email(opts)
    |> validate_password(opts)
  end

  @doc """
    This def updates the user totally. It is only for the superadmin
  """
  def update_changeset_total(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:username, :email, :password, :time_contract, :role_id])
    |> validate_required([:username, :email, :time_contract, :role_id])
    |> validate_email(opts)
    |> maybe_validate_password(opts)
  end

  @doc """
    This def update changeset only updates the username and password.
    This is when you try to update yourself and are not a superadmin.
  """
  def update_changeset_current_user(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username])
    |> maybe_validate_password(opts)
  end

  @doc """
    This def changeset is updates everything but the role. It is use to update an other user. Only for managers
  """
  def update_changeset_other_user(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:username, :email, :password, :time_contract])
    |> validate_required([:username, :email, :time_contract])
    |> validate_email(opts)
    |> maybe_validate_password(opts)
  end

  defp maybe_validate_password(changeset, opts) do
    password = get_change(changeset, :password)

    if is_nil(password) do
      changeset
    else
      changeset
      |> validate_password(opts)
    end
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    # Examples of additional password validation:
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Timemanager.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Timemanager.Account.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end
end
