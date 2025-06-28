// https://www.shadertoy.com/view/4slXW7

//2D Voxels by nimitz (stormoid.com) (twitter: @stormoid)

//try the other maps
#define MAP 1
#define NUM_LAYERS 46.

#define time iTime

mat3 rotXY( vec2 angle )
{
	vec2 c = cos( angle );
	vec2 s = sin( angle );
	return mat3(c.y      ,  0.0, -s.y,
				s.y * s.x,  c.x,  c.y * s.x,
				s.y * c.x, -s.x,  c.y * c.x	);
}

#if MAP == 1
float map( vec3 p )
{
	//vec3 q = mod(pos,c)-0.5*c;
	p *= rotXY(vec2(time*.9,time*0.6));
	const float w = 1.5;
	vec3 q = abs(p);
	float d = max(max(q.z,q.y),q.x*0.15)-w;
	q*= .7;
	d = min(d,max(max(q.z,q.x),q.y*0.15))-w;
	q*= .5;
	d = min(d,max(max(q.x,q.y),q.z*0.15))-w;

	return d;
}
#elif MAP == 2
//sphere/cube subtract
float map( vec3 p )
{
	p *= rotXY(vec2(time*0.6,time*.9));

	float d1 = length(p)-20.;
	float d2 = length(max(abs(p)-16., 0.));

	return max(d2, -d1);
}
#else
//heightmap (can handle many layers, 200 works fine here)
float map( vec3 p )
{
	p *= rotXY(vec2(0.5,10.6));
	p.y += sin(p.z*0.1+time)*(3.+sin(time)*1.);
	p.y += sin(p.x*0.5+time)*(3.+sin(time)*1.);
	return length(p.y)-2.;
}
#endif

vec3 lgt;

//modified from iq's "Hexagons - distance" (https://www.shadertoy.com/view/Xd2GR3)
//return values: x = trigger, y = voxel shading, z = distance to voxel edge, w = lighting
vec4 voxelize( vec2 p, float bias )
{
	//displace based on layer
	p.x += 0.866025*bias;
	p.y += 0.5*bias;

	//setup coord system
	vec2 q = vec2( p.x*2.0*0.5773503, p.y + p.x*0.5773503 );
	vec2 pi = floor(q);
	vec2 pf = fract(q);

	float v = mod(pi.x + pi.y, 3.0);

	float ca = step(1.0,v);
	float cb = step(2.0,v);
	vec2  ma = step(pf.xy,pf.yx);

    // distance to borders
	vec2 bz = 1.0-pf.yx + ca*(pf.x+pf.y-1.0) + cb*(pf.yx-2.0*pf.xy);
	float e = dot( ma, bz );

	//voxel shading
	float top = cb*ma.y+clamp((1.-(ca+ma.y)),0.,1.);
	float left = 0.5+step(ca,cb)*0.75;

	vec2 j = pi + ca - cb*ma;
	float sdf = map(vec3(j,bias));

	//faked light (using the normal only, actual lighting gets pretty heavy)
	float nl = max(dot(normalize(lgt),normalize(vec3(j,bias))),0.);
	return vec4( step(sdf,.01),left+top, e, nl*2. );
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    lgt =  vec3(4.+sin(time*0.4)*20.,4.+sin(time*.1)*10.,5.);
    vec2 p = fragCoord.xy/iResolution.xy-0.5;
	p.x *= iResolution.x/iResolution.y;
	vec2 bp = p;
	p *= 100.+sin(time*0.5)*80.;
	p.x += sin(time)*10.;
	p.y += cos(time*0.9+0.5)*4.;

	float st = sin(time*0.2)*0.3+1.;
	vec3 col = vec3(0.);
	for (float i=-NUM_LAYERS/2.;i<NUM_LAYERS/2.;i++)
	{
		vec4 rz = voxelize(p,i);
		//vec3 colx = (.95 + 0.8*sin( hash11(rz.x+i)*1.5 + 2.0 + vec3(1.5+i*0.2, st*1.5+i*0.1, 1.0+i*0.01) ))*rz.x*4.;
		vec3 colx = vec3(0.15+cos(time+0.1)*0.1,0.2,0.3+sin(time)*0.1)*rz.x*3.;
		//borders
		//colx *= smoothstep(0., 0.1, rz.z);
		//simple shading
		colx *= .4+rz.z*.9;
		//voxel shading
		colx *= rz.y*.5;
		//faked lighting
		colx *= rz.w*0.5+0.5;
		//painter's algo
		col = col*step(colx,vec3(0.))+colx;
		//max blending (transparency! :P)
		//col += colx*0.4;
	}

	float d = distance(lgt,vec3(p,1.));
	col += 1.-smoothstep(0.92,1.,(d*.24));

	fragColor = vec4( col*1.3, 1.0 );
}

