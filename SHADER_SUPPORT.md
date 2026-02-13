# Shader Language Support

This configuration adds support for shader programming languages in Neovim.

## Supported Languages

### GLSL (OpenGL Shading Language)
- **Extensions**: `.glsl`, `.vert`, `.frag`, `.tesc`, `.tese`, `.geom`, `.comp`
- **Use Cases**: OpenGL shader development
- **LSP**: glsl_analyzer (prioritized), glslls (fallback via Mason)

### HLSL (High-Level Shading Language)
- **Extensions**: `.hlsl`, `.hlsli`, `.fx`, `.fxh`, `.vsh`, `.psh`, `.vs`, `.ps`, `.gs`, `.cs`
- **Use Cases**: DirectX shader development
- **LSP**: Not configured by default (limited LSP support available)

### WGSL (WebGPU Shading Language)
- **Extensions**: `.wgsl`
- **Use Cases**: WebGPU shader development
- **LSP**: Not configured by default (wgsl-analyzer in development)

## Features

1. **Syntax Highlighting**: Treesitter-based syntax highlighting for all shader languages
2. **File Type Detection**: Automatic detection of shader files by extension
3. **LSP Support**: glsl_analyzer for GLSL (autocomplete, hover, basic diagnostics)
4. **Advanced Linting**: glslangValidator (Vulkan SDK) for comprehensive shader validation
5. **Proper Indentation**: 4-space indentation with proper comment strings

## Diagnostic Sources

For GLSL files, you get diagnostics from TWO sources:

1. **glsl_analyzer** (LSP): Basic syntax errors, type checking, undefined variables
2. **glslangValidator** (Linter): Comprehensive validation including:
   - GLSL version compliance
   - Shader stage-specific rules
   - Layout qualifiers
   - Built-in variable usage
   - Extension requirements

This dual approach provides both real-time LSP features AND thorough validation.

## Installation

The shader language parsers will be automatically installed by Treesitter on first use.

### Optional: Install GLSL LSP

For enhanced GLSL development with LSP features (autocomplete, diagnostics, etc.), you have two options:

**Option 1: glsl_analyzer (RECOMMENDED - prioritized in config)**

More features and better support, requires building from source:

```bash
# Clone and build from source
git clone https://github.com/nolanderc/glsl_analyzer
cd glsl_analyzer
cargo build --release
# Copy the binary to your PATH
sudo cp target/release/glsl_analyzer /usr/local/bin/
```

**Option 2: glslls (Easier to install, used as fallback)**

```bash
# Install via Mason in Neovim
:MasonInstall glslls
```

The configuration prioritizes `glsl_analyzer` - if both are installed, it will use `glsl_analyzer` first.

## File Structure

- `lua/plugins/treesitter.lua` - Treesitter parser configuration
- `lua/plugins/shader.lua` - Shader file type detection and LSP setup
- `after/ftplugin/glsl.lua` - GLSL-specific buffer settings
- `after/ftplugin/hlsl.lua` - HLSL-specific buffer settings
- `after/ftplugin/wgsl.lua` - WGSL-specific buffer settings

## Usage

Simply open any shader file with a supported extension, and syntax highlighting will be enabled automatically.

### Example GLSL Shader

```glsl
#version 450

layout(location = 0) in vec3 position;
layout(location = 1) in vec3 color;

layout(location = 0) out vec3 fragColor;

void main() {
    gl_Position = vec4(position, 1.0);
    fragColor = color;
}
```

### Example HLSL Shader

```hlsl
struct VSInput {
    float3 position : POSITION;
    float3 color : COLOR;
};

struct PSInput {
    float4 position : SV_POSITION;
    float3 color : COLOR;
};

PSInput VSMain(VSInput input) {
    PSInput output;
    output.position = float4(input.position, 1.0);
    output.color = input.color;
    return output;
}
```

### Example WGSL Shader

```wgsl
struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) color: vec3<f32>,
};

@vertex
fn vs_main(@location(0) position: vec3<f32>, @location(1) color: vec3<f32>) -> VertexOutput {
    var output: VertexOutput;
    output.position = vec4<f32>(position, 1.0);
    output.color = color;
    return output;
}
```

## Notes

- The LSP errors about `vim` being undefined are false positives from the Lua language server and can be ignored
- Treesitter will automatically install shader parsers on first launch
- For the best experience with GLSL, install `glsl_analyzer`
