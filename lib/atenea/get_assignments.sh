#!/bin/bash
host="https://atenea.upc.edu"
token="02254ae7f5688e1f4a51819c30619d14"
function="mod_assign_get_assignments"
params="&courseids%5B0%5D=72714&courseids%5B1%5D=66976"

curl "$host/webservice/rest/server.php?wstoken=$token&wsfunction=$function&moodlewsrestformat=json$params"
