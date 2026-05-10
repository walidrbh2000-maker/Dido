<?php

return [

    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['*'],

    /*
    |----------------------------------------------------------------------
    | IMPORTANT: must be an array — NOT a string.
    | env() returns a string; PHP 8.2 throws TypeError in in_array()
    | if the second argument is not an array.
    |----------------------------------------------------------------------
    */
    'allowed_origins' => ['*'],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => false,

];
