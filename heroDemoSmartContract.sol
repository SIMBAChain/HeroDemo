pragma solidity ^0.4.18;

contract Application {
    function Application() public {}

    function Review_Hero (
        string SuperHero_TagID,
        uint Date_Reviewed,
        string Hero_Manager,
        string Job_To_Do,
        string Review_Comments,
        bytes32 assetId,
        bytes32 SuperHero)
    public {}

    function Procure_Hero_Service (
        string SuperHero_TagID,
        string Hero_Manager,
        string Job_To_Do,
        uint Date_Procured,
        bytes32 assetId,
        bytes32 SuperHero)
    public {}

    function Register_Hero (
        string SuperHero_TagID,
        string SuperHero_CodeName,
        bytes32 assetId,
        bytes32 SuperHero)
    public {}
}