local http = require 'resty.http'
local cjson = require 'cjson'
local base64 = require 'base64'
local crypto = require 'crypto'
local utils = require 'utils'
local httpc = http.new()

-- Module declaration
local M 

local function acquireTokenWithClientCertificate(authority, resource, clientId, certificate, thumbprint) 
    local required = {
        authority = 'string',
        resource = 'string',
        clientId = 'string',
        certificate = 'string',
        thumbprint = 'string'
    }
    -- TODO: check args

    local client_assertion = utils.create_assertion(authority, resource, clientId, certificate, thumbprint)

    local token_req = {
        grant_type= 'client_credentials',
        client_id = clientId,
        client_assertion_type = 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer',
        client_assertion = client_assertion,
        resource = resource
    }

    headers = {
        ["Content-Type"] = 'application/x-www-form-urlencoded'
    }

    response = httpc:request_uri(
        authority, {
            method = "POST",
            headers = headers,
            body = utils.url_encode_table(token_req)
        }
    )
        
    local json = assert(cjson.decode(response.text))
    return json.access_token
end

local function acquireTokenWithClientSecret(authority, resource, clientId, secret) 
    local required = {
        authority = 'string',
        resource = 'string',
        clientId = 'string',
        certificate = 'string',
        thumbprint = 'string'
    }
    
    -- TODO: check args

    local client_assertion = utils.create_assertion(authority, resource, clientId, certificate, thumbprint)

    local token_req = {
        grant_type= 'client_credentials',
        client_id = clientId,
        client_secret = secret,
        resource = resource
    }

    headers = {
        ["Content-Type"] = 'application/x-www-form-urlencoded'
    }

    response = httpc:request_uri(
        authority, {
            method = "POST",
            headers = headers,
            body = utils.url_encode_table(token_req)
        }
    )
        
    local json = assert(cjson.decode(response.text))
    return json.access_token
end

M = {
    acquireTokenWithClientCertificate = acquireTokenWithClientCertificate,
    acquireTokenWithClientSecret = acquireTokenWithClientSecret
}

return M