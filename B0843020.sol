pragma solidity >=0.4.22 <0.6.0;

contract B0843020 {
     
    struct Proposal {
        string name;  //候選人的姓名
        uint voteCount;//候選人的投票計數
    }
     
    struct Voter {
        uint weight;    //投票人的權重
        bool voted;     //投票人是否投過票了
        uint votedProposal; //投票人投給誰
    }
    
    Proposal[] proposals; //候選人
    address leader; //發起投票的人(這個投票合約的擁有者)
    mapping(address => Voter) voters; //利用投票者的地址追蹤Voter裡的struct的資訊,以利追蹤
     
    //建構子,在建構的時候順便紀錄發起人(leader)是誰
    constructor() public {
        leader = msg.sender; //發起投票的人
        voters[leader].weight = 1; //發起投票的人的投票權重(發起人也可以投1票)

        //把所有候選人加進提案列表
        proposals.push(Proposal({
            name: "阿糖",
            voteCount: 0
        }));

        proposals.push(Proposal({
            name: "力量人",
            voteCount: 0
        }));
    }
     
    //由leader指定那些人可以投票
    //確保每個人只能用一個帳號投票
    function giveRightToVote(address voter) public {
        require(msg.sender == leader);          //確認使用這個function的人是leader
        require(voters[voter].voted == false);  //確認要被授權投票權利的人是還沒有投票的人
        require(voters[voter].weight == 0);     //確認要被授權投票權利的人是沒有投票權利的人
         
        voters[voter].weight = 1;               //以上都有符合的話,把這個人的投票權重設為1
    }
     
    //投票環節
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];  //用storage修飾這個變數讓這個投票者的資訊會被記錄在區塊鏈上
        require(sender.voted ==false);              //確認投票者是還沒有投過票的人
        require(sender.weight > 0);                 //確認投票者是有權利投票的人
         
        sender.votedProposal = proposal;            //將投票者投給誰的結果記錄在區塊鍊上
        sender.voted = true;                        //將投票者設為已投票

        proposals[proposal].voteCount += sender.weight;//把候選人的票數加上去
    }
     
    //開票環節
    //要在資訊欄位看到目前的最高票數,還有候選人的姓名
    function showWinningProposal() public view returns (uint winningProposal , string memory winningProposalName) { 
        uint maxVote = 0; 
        //利用for迴圈找出所有提案得票數最多的
        for(uint i = 0; i < proposals.length; i++) {
            if(proposals[i].voteCount > maxVote) {
                maxVote = proposals[i].voteCount;
                winningProposal = i;                    //紀錄最高票
                winningProposalName=proposals[i].name;  //紀錄姓名
            }
        }
    }
}