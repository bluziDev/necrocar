shader_type spatial;

//render_mode unshaded;

uniform vec3 col : source_color;
uniform sampler2D height_map;
uniform sampler2D normal_map;
uniform float terrain_max_height;
//varying float height;
varying vec2 tex_pos;

void vertex() {
	//displace vertices according to heightmap
	vec4 world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0));
	vec2 height_map_size = vec2(textureSize(height_map,0));
	vec2 noise_offset = height_map_size / 2.0;
	tex_pos = (world_vertex.xz + noise_offset) / height_map_size;
	float height = texture(height_map,tex_pos).r;
	world_vertex.y += height * terrain_max_height;
	VERTEX = (inverse(MODEL_MATRIX) * world_vertex).xyz;
}

void fragment() {
	ALBEDO = col;//vec3(height);
	NORMAL_MAP = texture(normal_map, tex_pos).xyz;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
