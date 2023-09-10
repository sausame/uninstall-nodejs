#!/bin/sh

function remove_folder()
{
    echo "--------------------------- $path"
    ls -l "$path"

    echo "rm -rf $path" >> $remove_files
    return

    echo "Remove $path?"
    read answer

    if [[ -n "${answer// /}" ]]; then
        echo "rm -rf $path"
        # rm -rf "$path"
    else
        echo "Skip $path"
    fi
}

function remove_file()
{
    echo "--------------------------- $path"
    /bin/ls -l "$path"

    echo "rm -f $path" >> $remove_files
    return

    echo "Remove $path?"
    read answer

    if [[ -n "${answer// /}" ]]; then
        echo "rm -f $path"
        # rm -rf "$path"
    else
        echo "Skip $path"
    fi
}

function safe_remove()
{
    local path=$1

    if [[ "${path}" == *"*"* ]]; then
        remove_folder "$path"
        return
    fi

    if [ -d "$path" ]; then
        remove_folder "$path"
        return
    fi

    if [ -f "$path" ]; then
        remove_file "$path"
        return
    fi

    if [ -L "$path" ]; then
        remove_file "$path"
        return
    fi
}

remove_files="remove.sh"
echo "" > "$remove_files"
chmod +x "$remove_files"

# Delete node, node-debug, and node-gyp from /usr/local/bin
safe_remove "/usr/local/bin/corepack"
safe_remove "/usr/local/bin/node"
safe_remove "/usr/local/bin/node-debug"
safe_remove "/usr/local/bin/node-gyp"

# Delete node and/or node_modules from /usr/local/include
safe_remove "/usr/local/include/node"
safe_remove "/usr/local/include/node_modules"

# Delete node and/or node_modules from /usr/local/lib
safe_remove "/usr/local/lib/node"
safe_remove "/usr/local/lib/node_modules"

# Delete node.d from /usr/local/lib/dtrace/
safe_remove "/usr/local/lib/dtrace/node.d"

# Delete node* from /usr/local/share/man/man1/
safe_remove "/usr/local/share/man/man1/node*"

# Delete npm* from /usr/local/share/man/man1/
safe_remove "/usr/local/share/man/man1/npm*"

# Delete node from /usr/local/share/doc/
safe_remove "/usr/local/share/doc/node"

# Delete node.stp from /usr/local/share/systemtap/tapset/
safe_remove "/usr/local/share/systemtap/tapset/node.stp"

# Delete node from /opt/local/bin/
safe_remove "/opt/local/bin/node"

# Delete node from /opt/local/include/
safe_remove "/opt/local/include/node"

# Delete node_modules from /opt/local/lib/
safe_remove "/opt/local/lib/node_modules"

# Delete org.nodejs.* from /var/db/receipts/
safe_remove "/var/db/receipts/org.nodejs.*"

# Delete .npmrc from your home directory (these are your npm settings, don't delete this if you plan on re-installing Node right away)
safe_remove "$HOME/.npmrc"

# Delete .npm from your home directory
safe_remove "$HOME/.npm"

# Delete .node-gyp from your home directory
safe_remove "$HOME/.node-gyp"

# Delete .node_repl_history from your home directory
safe_remove "$HOME/.node_repl_history"

# References
# https://stackoverflow.com/questions/11177954/how-do-i-completely-uninstall-node-js-and-reinstall-from-beginning-mac-os-x
# https://stackabuse.com/how-to-uninstall-node-js-from-mac-osx/