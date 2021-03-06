/**
 *
 * Hungry Hero Game
 * http://www.hungryherogame.com
 * 
 * Copyright (c) 2012 Hemanth Sharma (www.hsharma.com). All rights reserved.
 * 
 * This ActionScript source code is free.
 * You can redistribute and/or modify it in accordance with the
 * terms of the accompanying Simplified BSD License Agreement.
 *  
 */

package 
{
	/**
	 * This class holds all particle files.  
	 * 
	 * @author hsharma
	 * 
	 */
	public class ParticleAssets
	{
		/**
		 * Particle 
		 */
		[Embed(source="../assets/particles/hit_particle.pex", mimeType="application/octet-stream")]
		public static var HitParticleXML:Class;
		[Embed(source="../assets/particles/smoke_particle.pex", mimeType="application/octet-stream")]
		public static var SmokeParticleXML:Class;
		
		
		[Embed(source="../assets/particles/star_texture.png")]
		public static var StarParticleTexture:Class;
		
		[Embed(source="../assets/particles/circle_texture.png")]
		public static var CircleParticleTexture:Class;
	}
}
