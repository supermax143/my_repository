package social.myworld.data
{
public interface IMWUser
{
	function toString(includeNickname:Boolean = false,userNonBreakableSpace:Boolean = true):String;
	function toObject():Object;
}
}