pragma solidity ^0.4.24;

import "./ERC721/ERC721.sol";
import "./ERC721/ERC721Enumerable.sol";

contract Klaystagram is ERC721, ERC721Enumerable {

    event EvaluationUploaded (uint256 indexed tokenId, address writer, uint256 star, string content, uint256 timestamp);

    mapping (uint256 => CourseData) private _courseList;
    mapping (uint256 => EvaluationData[]) private _evaluationList;
    mapping (address => Userr) private _userList;

    struct User {
        address userAddress;
        string email;
    }

    struct CourseData {
        uint256 id;
        string name;
        string professor;
    }

    struct EvaluationData {
        uint256 tokenId;
        address writer;
        uint256 star;
        string content;
        uint256 timestamp;
    }

    function findUser(address _address) public view returns(bool) {
        return _userList[_address];
    }

  /**
   * @notice _mint() is from ERC721.sol
   */
    function uploadEvaluation(uint courseId, uint256 star, string content) public {
        uint256 tokenId = totalSupply() + 1;

        _mint(msg.sender, tokenId);

        address[] memory ownerHistory;

        EvaluationData memory newEvaluationData = EvaluationData({
            tokenId : tokenId,
            writer : msg.sender,
            star : star,
            content : content,
            timestamp : now
        });

        _evaluationList[courseId].push(newEvaluationData);

        emit EvaluationUploaded(tokenId, msg.sender, star, content, now);
    }

  /**
   * @notice safeTransferFrom function checks whether receiver is able to handle ERC721 tokens
   *  and then it will call transferFrom function defined below
   */
    function transferOwnership(uint256 tokenId, address to) public returns(uint, address, address, address) {
        safeTransferFrom(msg.sender, to, tokenId);
        uint ownerHistoryLength = _photoList[tokenId].ownerHistory.length;
        return (
            _photoList[tokenId].tokenId, 
            //original owner
            _photoList[tokenId].ownerHistory[0],
            //previous owner, length cannot be less than 2
            _photoList[tokenId].ownerHistory[ownerHistoryLength-2],
            //current owner
            _photoList[tokenId].ownerHistory[ownerHistoryLength-1]);
    }

  /**
   * @notice Recommand using transferOwnership, which uses safeTransferFrom function
   * @dev Overided transferFrom function to make sure that every time ownership transfers
   *  new owner address gets pushed into ownerHistory array
   */
    function transferFrom(address from, address to, uint256 tokenId) public {
        super.transferFrom(from, to, tokenId);
        _photoList[tokenId].ownerHistory.push(to);
    }

    function getTotalPhotoCount () public view returns (uint) {
        return totalSupply();
    }

    function getPhoto (uint tokenId) public view 
    returns(uint256, address[], bytes, string, string, string, uint256) {
        require(_photoList[tokenId].tokenId != 0, "Photo does not exist");
        return (
            _photoList[tokenId].tokenId, 
            _photoList[tokenId].ownerHistory, 
            _photoList[tokenId].photo, 
            _photoList[tokenId].title, 
            _photoList[tokenId].location, 
            _photoList[tokenId].description,
            _photoList[tokenId].timestamp);
    }
}