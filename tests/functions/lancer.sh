#!/bin/sh
# Teste la fonction manage-users avec un faux client Supabase (aucun appel réseau). Nécessite Node 22+.
cd "$(dirname "$0")" || exit 1
sed 's#import { createClient } from "npm:@supabase/supabase-js@2";#import { createClient } from "./mock.ts";#' ../../supabase/functions/manage-users/index.ts > fn.ts
node --experimental-strip-types run.ts 2>&1 | grep -v -i warning
rm -f fn.ts
