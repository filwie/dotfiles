vim.filetype.add({
  pattern = {
    [".*/tasks/.*.yaml"] = "yaml.ansible",
    [".*playbook.*.yaml"] = "yaml.ansible",
  },
})
