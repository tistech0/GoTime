defmodule Timemanager.AccountTest do
  use Timemanager.DataCase

  alias Timemanager.Account

  describe "users" do
    alias Timemanager.Account.User

    import Timemanager.AccountFixtures

    @invalid_attrs %{email: nil, password: nil, time_contract: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", password: "some password", time_contract: 42, username: "some username"}

      assert {:ok, %User{} = user} = Account.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.password == "some password"
      assert user.time_contract == 42
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", password: "some updated password", time_contract: 43, username: "some updated username"}

      assert {:ok, %User{} = user} = Account.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.password == "some updated password"
      assert user.time_contract == 43
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end
