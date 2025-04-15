// In house .env file parser
use std::collections::HashMap;
use std::fs::File;
use std::io::{self, Read, BufRead, BufReader};

// Function to parse a single line from the .env file
fn parse_env_line(line: &str) -> Option<(String, String)> {
    let line = line.trim();

    // Skip empty lines and comments
    if line.is_empty() || line.starts_with('#') {
        return None;
    }

    // Split the line into key and value
    let mut parts = line.splitn(2, '=');
    let key = parts.next()?.trim();
    let value = parts.next()?.trim();

    // Handle quoted values (e.g., KEY="value with spaces")
    let value = if value.starts_with('"') && value.ends_with('"') {
        &value[1..value.len() - 1]
    } else {
        value
    };

    Some((key.to_string(), value.to_string()))
}

// Function to read the .env file and return a HashMap of environment variables
pub fn read_env_file(file_path: &str) -> io::Result<HashMap<String, String>> {
    let file = File::open(file_path)?;
    let reader = BufReader::new(file);
    let mut env_vars = HashMap::new();

    for line in reader.lines() {
        let line = line?;
        if let Some((key, value)) = parse_env_line(&line) {
            env_vars.insert(key, value);
        }
    }

    Ok(env_vars)
}

