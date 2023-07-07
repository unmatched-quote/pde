#!/bin/bash
set -em

sleep 5

if [ ! -f "/etc/vault.d/unseal-keys.json" ];
then
    INIT_RESPONSE=$(vault operator init -format=json -key-shares 1 -key-threshold 1)
    echo "$INIT_RESPONSE" > /etc/vault.d/unseal-keys.json

    UNSEAL_KEY=$(echo "$INIT_RESPONSE" | jq -r .unseal_keys_b64[0])
    VAULT_TOKEN=$(echo "$INIT_RESPONSE" | jq -r .root_token)

    vault operator unseal "$UNSEAL_KEY"
    vault login "$VAULT_TOKEN"

     # Create admin policy
    vault policy write admin-users /etc/vault.d/policies/admin-policy.hcl

    # Enable username + password login
    vault auth enable userpass

    # Create the phpdev admin user
    vault write auth/userpass/users/pde policies=admin-users password=pde

    # Create php development environment (pde) kv mount
    vault secrets enable -path=pde -version=2 kv
else
    # We're starting vault back up (it exists), read the existing keys and unseal the vault
    INIT_RESPONSE=$(cat /etc/vault.d/unseal-keys.json)
    UNSEAL_KEY=$(echo "$INIT_RESPONSE" | jq -r .unseal_keys_b64[0])

    vault operator unseal "$UNSEAL_KEY"
fi;