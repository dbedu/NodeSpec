# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NodeSpec is a VPS benchmarking script that runs tests in a sandboxed environment and formats the results. It's a pre-loader and post-processor for various server testing tools, designed to standardize and automate the server testing workflow.

## Core Architecture

- **Main script**: `NodeSpec.sh` - The primary entry point that orchestrates the entire testing process
- **Modular components**: The `part/` directory contains individual test modules:
  - `yabs.sh` - Disk and network performance testing (45KB, core functionality)
  - `sysbench.sh` - CPU and memory benchmarking
  - `trace.sh` - Network routing tests
  - `swap.sh` - Memory swap testing
  - `header.sh` - System information gathering
- **Provider data**: `providers/data.json` contains VPS provider information for quality analysis
- **Sandbox approach**: Uses chroot with a Debian rootfs (BenchOS) to isolate testing environment

## Key Execution Flow

1. Downloads and sets up BenchOS sandbox environment
2. Mounts the sandbox using chroot
3. Executes test modules in isolation within BenchOS
4. Collects results in structured log files
5. Uploads results to temporary clipboard service
6. Automatically cleans up all traces

## Running the Script

The main command to execute the benchmark:
```bash
bash <(curl -sL https://run.nodespec.com)
```

Or run locally:
```bash
bash NodeSpec.sh
```

## Testing and Development

No traditional build/test commands exist as this is a bash script project. To test changes:

1. Run the main script directly: `bash NodeSpec.sh`
2. Test individual components: `bash part/yabs.sh` (within BenchOS environment)
3. Validate JSON data: Use `jq` to validate `providers/data.json` format

## File Structure

- Output files are created in temporary `.NodeSpecYYYY_MM_DD_HH_MM_SS/` directories
- Log files follow specific naming conventions (e.g., `yabs.json`, `ip_quality.log`)
- BenchOS sandbox is downloaded from GitHub releases (supports x86_64 and ARM)

## Important Notes

- The script is designed for "traceless testing" - all temporary files are automatically cleaned up
- Uses Chinese language primarily in documentation and output
- Integrates multiple existing benchmark tools (YABS, IP quality checks, network tests)
- Provider data modifications should be added to the end of the JSON array in `providers/data.json`