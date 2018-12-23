uniform float time;
uniform float progress;
uniform vec2 resolution;
uniform vec2 cameraRotation;
uniform sampler2D texture1;
uniform sampler2D texture2;

varying vec2 vUv;

vec2 warp(vec2 pos, vec2 amplitude)
{
    pos  = pos * 2.0-1.0;
    pos.x *= 1.0 - (pos.y*pos.y)*amplitude.x * 0.2;
    pos.y *= 1.0 + (pos.x*pos.x)*amplitude.y;
    return pos*0.5 + 0.5;
}


void main()	{

	float myprogress = fract(progress);



	vec2 warpedUV = warp(vUv, vec2(-0.9));
	// warpedUV = vUv;
	// vignette

	vec2 center = (gl_FragCoord.xy/resolution.xy) - vec2(0.5);

	float len = length(center);

	float vignette = 1. - smoothstep(0.4, 0.75,len);

	vec2 uvCurrent = vec2(
		warpedUV.x + myprogress*0.8 + cameraRotation.x, 
		warpedUV.y - myprogress*0.5 - cameraRotation.y
	);
	vec2 uvNext = vec2(
		warpedUV.x - (1. - myprogress) + cameraRotation.x, 
		warpedUV.y + (1. - myprogress)*0.3 - cameraRotation.y
	);



	vec4 imgCurrent = texture2D(texture1,uvCurrent);
	vec4 imgNext = texture2D(texture2,uvNext);


	vec3 colorCurrent = imgCurrent.rgb*(1. - myprogress);
	vec3 colorNext = imgNext.rgb*myprogress;


	// vec4 final = mix(imgCurrent,imgNext,progress);

	gl_FragColor = vec4(colorCurrent + colorNext, 1.);
	gl_FragColor.rgb = mix(gl_FragColor.rgb*0.5, gl_FragColor.rgb, vignette);
	// gl_FragColor = vec4(vignette,0.,0., 1.);
}