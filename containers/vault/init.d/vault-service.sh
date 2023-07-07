#!/bin/bash
set -em

vault_start_server() {
    vault server -config=/etc/vault.d/vault.json &

    # This is disgusting hack with "sleep 5", you can't hate me more than I hate myself
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
}

# Start the service. Note: vault is NOT unsealed and there are no keys or admin token created
vault_start_server

