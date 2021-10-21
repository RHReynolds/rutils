# Solve "no visible binding for global variable '.data' or '.' issue"
utils::globalVariables(c(".data", "."))
