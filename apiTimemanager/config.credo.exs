%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["*.exs", "src/", "test/", "lib/", "apps/"],
        excluded: [~r"/_build/", ~r"/deps/"]
      }
    }
  ]
}
