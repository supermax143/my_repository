package social.vkontakte.data
{
public interface IVKUser
{
   function toString(includeNickname:Boolean = false,userNonBreakableSpace:Boolean = true):String;
   function toObject():Object;
}
}