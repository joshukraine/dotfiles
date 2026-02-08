-- Extend neotest with minitest adapter for Rails projects.
-- LazyVim's lang.ruby extra already provides neotest-rspec.
-- LazyVim's lang.python extra already provides neotest-python.

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "zidhuss/neotest-minitest",
    },
    opts = {
      adapters = {
        ["neotest-minitest"] = {
          test_cmd = function()
            return {
              "bundle",
              "exec",
              "rails",
              "test",
            }
          end,

          -- Docker: Uncomment the block below (and comment out test_cmd above)
          -- to run minitest inside a Docker container via docker compose.
          -- Adjust the service name ("app") and working directory as needed.
          --
          -- test_cmd = function()
          --   return {
          --     "docker",
          --     "compose",
          --     "exec",
          --     "-i",
          --     "-w", "/app",
          --     "-e", "RAILS_ENV=test",
          --     "app",
          --     "bundle",
          --     "exec",
          --     "rails",
          --     "test",
          --   }
          -- end,
          --
          -- transform_spec_path = function(path)
          --   local prefix = require("neotest-minitest").root(path)
          --   return string.sub(path, string.len(prefix) + 2, -1)
          -- end,
          --
          -- results_path = "tmp/minitest.output",
        },
      },
    },
  },
}
