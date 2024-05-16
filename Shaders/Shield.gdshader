shader_type canvas_item;

uniform float radius : hint_range(0.0, 100.0);
uniform vec2 player_pos;

void fragment() {
    // Calcul des coordonnées du pixel dans l'espace du joueur
    vec2 frag_pos = (vec2(0.5, 0.5) - SCREEN_UV) * vec2(2.0, -2.0) * radius + player_pos;
    
    // Calcul de la distance au centre du joueur
    float distance = length(frag_pos - player_pos);
    
    // Définir la couleur du pixel en fonction de la distance
    if (distance < radius) {
        // Pixel à l'intérieur de la bulle (bouclier)
        float alpha = 0.3;
        vec4 shield_color = vec4(0.0, 0.0, 1.0, alpha); // Couleur bleue du bouclier
        
        COLOR = shield_color;
		
    }
}
