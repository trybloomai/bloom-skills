# Offline checks for Bloom's portable Agent Plugins 1.0.0 profile.
# Uses POSIX awk, not a general JSON Schema engine. Parse JSON before checking
# types and the closed field sets used here; reject duplicate object keys.
# Contract: https://agent-plugins.org/specification

function abort(message) {
    print "Error: " FILENAME ": " message > "/dev/stderr"
    exit 1
}

function whitespace() {
    while (substr(document, position, 1) ~ /^[ \t\r\n]$/) position++
}

function hex4(    token, i, digit, result) {
    token = substr(document, position, 4)
    if (length(token) != 4 || token ~ /[^0-9a-fA-F]/) abort("Invalid Unicode escape")
    position += 4
    for (i = 1; i <= 4; i++) {
        digit = index("0123456789abcdef", tolower(substr(token, i, 1))) - 1
        result = result * 16 + digit
    }
    return result
}

function utf8(code) {
    if (code < 128) return sprintf("%c", code)
    if (code < 2048) return sprintf("%c%c", 192 + int(code / 64), 128 + code % 64)
    if (code < 65536) return sprintf("%c%c%c", 224 + int(code / 4096), 128 + int(code / 64) % 64, 128 + code % 64)
    return sprintf("%c%c%c%c", 240 + int(code / 262144), 128 + int(code / 4096) % 64, 128 + int(code / 64) % 64, 128 + code % 64)
}

function string(    result, c, code, low) {
    if (substr(document, position++, 1) != "\"") abort("Expected a JSON string")
    while (position <= length(document)) {
        c = substr(document, position++, 1)
        if (c == "\"") return result
        if (c ~ /[[:cntrl:]]/) abort("Control character in JSON string")
        if (c == "\\") {
            c = substr(document, position++, 1)
            if (c == "u") {
                code = hex4()
                if (code >= 55296 && code <= 56319) {
                    if (substr(document, position, 2) != "\\u") abort("Missing low surrogate")
                    position += 2
                    low = hex4()
                    if (low < 56320 || low > 57343) abort("Invalid low surrogate")
                    code = 65536 + (code - 55296) * 1024 + low - 56320
                } else if (code >= 56320 && code <= 57343) abort("Unpaired low surrogate")
                c = utf8(code)
            } else if (c == "b") c = sprintf("%c", 8)
            else if (c == "f") c = sprintf("%c", 12)
            else if (c == "n") c = "\n"
            else if (c == "r") c = "\r"
            else if (c == "t") c = "\t"
            else if (c != "\"" && c != "\\" && c != "/") abort("Invalid JSON escape")
        }
        result = result c
    }
    abort("Unterminated JSON string")
}

function value(    node, c, key, item) {
    whitespace()
    if (++depth > 64) abort("Excessive JSON nesting")
    node = ++nodes
    c = substr(document, position, 1)
    if (c == "{" || c == "[") {
        types[node] = (c == "{" ? "object" : "array")
        position++
        whitespace()
        if (substr(document, position, 1) != (c == "{" ? "}" : "]")) {
            while (1) {
                whitespace()
                if (c == "{") {
                    key = string()
                    if ((node SUBSEP key) in children) abort("Duplicate JSON key: " key)
                    whitespace()
                    if (substr(document, position++, 1) != ":") abort("Expected colon")
                } else key = size[node] + 1
                item = value()
                children[node, key] = item
                keys[node, ++size[node]] = key
                whitespace()
                if (substr(document, position, 1) != ",") break
                position++
            }
        }
        if (substr(document, position++, 1) != (c == "{" ? "}" : "]")) abort("Expected closing delimiter")
    } else if (c == "\"") {
        types[node] = "string"
        values[node] = string()
    } else if (match(substr(document, position), /^-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)?/)) {
        types[node] = "number"
        position += RLENGTH
    } else if (substr(document, position, 4) == "true" || substr(document, position, 4) == "null") {
        types[node] = (c == "t" ? "boolean" : "null")
        position += 4
    } else if (substr(document, position, 5) == "false") {
        types[node] = "boolean"
        position += 5
    } else abort("Invalid JSON value at character " position)
    depth--
    return node
}

function type(node, expected, label) {
    if (types[node] != expected) abort(label " must be a JSON " expected)
}

function member(node, key, expected,    item) {
    item = children[node, key]
    type(item, expected, key)
    return item
}

function closed(node, allowed, label,    fields, total, i, j, key, found) {
    type(node, "object", label)
    total = split(allowed, fields, " ")
    for (i = 1; i <= size[node]; i++) {
        key = keys[node, i]
        found = 0
        for (j = 1; j <= total; j++) if (key == fields[j]) found = 1
        if (!found) abort("Unsupported field in " label ": " key)
    }
}

function exact(node, key, expected) {
    if (values[member(node, key, "string")] != expected) abort(key " must equal " expected)
}

{ document = document $0 "\n" }

END {
    position = 1
    root = value()
    whitespace()
    if (position <= length(document)) abort("Trailing data after JSON document")
    if (kind == "plugin") {
        closed(root, "$schema name version description author homepage repository license keywords extensions", "plugin.json")
        exact(root, "$schema", "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json")
        exact(root, "name", expected_name)
        exact(root, "version", expected_version)
        # The requested ChatGPT website link is the only client-specific data
        # shipped here. Keep its namespace and presentation fields closed.
        extensions = member(root, "extensions", "object")
        closed(extensions, "com.openai", "extensions")
        openai = member(extensions, "com.openai", "object")
        closed(openai, "interface", "com.openai")
        interface = member(openai, "interface", "object")
        closed(interface, "websiteURL", "com.openai.interface")
        exact(interface, "websiteURL", "https://www.trybloom.ai")
        for (i = 1; i <= size[root]; i++) {
            key = keys[root, i]
            item = children[root, key]
            if (key == "author") {
                closed(item, "name email url", "author")
                for (j = 1; j <= size[item]; j++) type(children[item, keys[item, j]], "string", "author field")
            } else if (key == "keywords") {
                type(item, "array", "keywords")
                for (j = 1; j <= size[item]; j++) type(children[item, j], "string", "keyword")
            } else if (key != "extensions") type(item, "string", key)
        }
    } else if (kind == "mcp") {
        closed(root, "$schema mcpServers", "mcp.json")
        exact(root, "$schema", "https://agent-plugins.org/schemas/1.0.0/mcp.schema.json")
        servers = member(root, "mcpServers", "object")
        if (size[servers] != 1 || !(servers SUBSEP expected_name in children)) abort("Expected exactly one MCP server named " expected_name)
        server = member(servers, expected_name, "object")
        closed(server, "type url", "Bloom MCP server")
        exact(server, "type", "streamable-http")
        exact(server, "url", "https://mcp.trybloom.ai/mcp")
    } else abort("Unknown validation profile")
}
