#!/bin/bash

vault_unseal() {
    local cmd;
    local started;
    cmd=$(vault_is_started)
    started=$?

    if [ $started -ne 0 ]; then
        echo "Vault server was not started, did you run vault start?";
        exit 1;
    fi;

    # Run auto-unseal which generates keys if vault is being booted for first time
    vault_auto_unseal
}

vault_is_started() {
    local response
    local i
    let exit_code

    for((i=0;i<5;i++)); do
         response=$(vault status | grep "Key")
         exit_code=$?

        if [ $exit_code -eq 0 ]; then
            exit 0;
        else
            sleep 1;
        fi;
    done

    exit 1;
}

vault_auto_unseal() {
    if [ ! -f "/etc/vault.d/unseal-keys.json" ];
    then
        local INIT_RESPONSE;
        local UNSEAL_KEY;
        local VAULT_TOKEN;

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

vault_unseal