# BDI Calculator

A command-line tool for calculating XXX XXX XXX (BDI) index for microbiome data.

## Description

`bdi_calculator` reads an input file and computes per-sample BDI values, printing results to stdout (one line per sample).

**Output format:** `<sample_id> <bdi_value>` (space-separated, BDI value as floating-point)

## Installation

Get the appropriate prebuilt binary for your system from the `Compiled-binaries/` directory:

- **macOS ARM:** `bdi_calculator-aarch64-apple-darwin`
- **Linux x86_64:** `bdi_calculator-x86_64-unknown-linux-musl`

Run the below codes (in the directory which contains these binaries)

### macOS (Apple Silicon - M1/M2/M3)
```bash
chmod +x bdi_calculator-aarch64-apple-darwin
sudo mv bdi_calculator-aarch64-apple-darwin /usr/local/bin/bdi_calculator
```

### Linux (x86_64)
```bash
chmod +x bdi_calculator-x86_64-unknown-linux-musl
sudo mv bdi_calculator-x86_64-unknown-linux-musl /usr/local/bin/bdi_calculator
```

## Usage

```bash
bdi_calculator --input <path> --sep <separator>
```

### Options

- `--input`: Path to the input data file (required)
- `--sep`: Field separator (optional, default: tab-delimited)

### Input File Format

The input file should contain microbiome data with fields separated by tabs, commas, or spaces. The tool expects:
- Rows: Taxonomic abundance as counts or relative abundance (at species level only)
- Columns: Sample names
- First column: Species names (the code auto-detects the taxa-name format and parses appropriately.) Preferred format example: "pseudomonas aeruginosa" 

## Examples

### Tab-separated input file
```bash
bdi_calculator --input ./example.txt --sep $'\t'
```

### Comma-separated input file
```bash
bdi_calculator --input ./data.csv --sep ','
```

### Save output to file
```bash
bdi_calculator --input ./data.txt > results.txt
```

## Output Example

```
sample_001 0.234567
sample_002 0.456789
sample_003 0.123456
```

## System Requirements

- macOS 11.0 or later (Apple Silicon)
- Linux with glibc 2.17 or later (x86_64)


## Note for Mac users: macOS may block unsigned binaries. 

If macOS shows a security warning, right-click → Open and click Open Anyway (one-time step)

OR run the following code in your terminal and retry

```bash
sudo xattr -d com.apple.quarantine /usr/local/bin/bdi_calculator
```

## License

[Need to add license information]

## Citation

If you use this tool in your research, please cite:
[Need to add citation information here]

## Contact

For questions or issues, please contact:
Jayanth Kumar Narayana (contact@jayanthinmathmedicine.com)
