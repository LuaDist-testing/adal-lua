local cjson = require 'cjson'
local hex = require 'hex'
local M

local function check_args(required, actual)
    for k, v in pairs(required) do
        if not (actual[k] and type(actual[k] == required[k])) then return false, "Missing argument: " .. k end
    end
    return true, nil
end

--URL encode a string.
local function url_encode_string(str)
    
    --Ensure all newlines are in CRLF form
    str = string.gsub (str, "\r?\n", "\r\n")

    --Percent-encode all non-unreserved characters
    --as per RFC 3986, Section 2.3
    --(except for space, which gets plus-encoded)
    str = string.gsub (str, "([^%w%-%.%_%~ ])",
    function (c) return string.format ("%%%02X", string.byte(c)) end)

    --Convert spaces to plus signs
    str = string.gsub (str, " ", "+")

    return str
end

--URL encode a table as a series of parameters.
local function url_encode_table(t)

    --table of argument strings
    local argts = {}

    --insertion iterator
    local i = 1

    --URL-encode every pair
    for k, v in pairs(t) do
    argts[i] = url_encode_string(k) .. "=" .. url_encode_string(v)
    i = i + 1
    end

    return table.concat(argts,'&')
end

local function create_assertion(authority, resource, clientId, certificate, thumbprint)
    local jwt_header = {
        alg = 'RS256',
        typ = 'JWT',
        x5t = hex.hextob64(thumbprint)
    }

    local jwt_payload = {
        aud = authority,
        iss = clientId,
        jti = tokenGUID,
        sub = clientId,
        nbf = tostring(os.time()),
        exp = tostring(os.time() + 3600)
    }

    local segments = {
        base64.encode(cjson.encode(jwt_header)),
        base64.encode(cjson.encode(jwt_payload))        
    }
    local sign_payload = table.concat(segments, ".")

    local key_obj = crypto.pkey.from_pem(certificate, true)
    local signature = crypto.sign("sha256", sign_payload, key_obj)

    segments[#segments+1] = base64.encode(signature)

    return table.concat(segments, '.')
end

M = {
    url_encode_table = url_encode_table,
    create_assertion = create_assertion
}


return M