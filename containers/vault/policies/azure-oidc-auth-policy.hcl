# Mount the OIDC auth method
path "sys/auth/oidc" {
  capabilities = [ "create", "read", "update", "delete", "sudo" ]
}

# Configure the OIDC auth method
path "auth/oidc/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# Write ACL policies
path "sys/policies/acl/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# List available secrets engines to retrieve accessor ID
path "sys/mounts" {
  capabilities = [ "read" ]
}

# Manage secrets engines
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List, create, update, and delete key/value secrets
path "secret/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}