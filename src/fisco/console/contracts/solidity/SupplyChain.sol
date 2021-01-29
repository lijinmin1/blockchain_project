pragma solidity >=0.4.22 <0.6.0;

contract Supplychain{

    struct Bank{
	    address ad; //唯一标识
        string name; //银行名字
    }

    struct Company{
	    address ad; //唯一标识
        string name; //公司名字
        bool creditValues; //信用额度
    }

    struct Receipt{
        uint id; //唯一标识
        address SME; //中小企业(收款方)
        address core; //核心企业(欠款方)
        uint amount; //金额
        uint start_date; //开始时间
        uint end_date; //还款时间
        bool isLoan; //是否用来贷款
        //uint loanAmount //贷款金额
        string info; //其他信息
    }
    
    Bank public bank;
    //Company public core;

    //地址到公司的映射
    mapping(address => Company) public companys;

    //地址到银行账户余额的映射
    mapping(address => uint) public balances;

    //应收款单据编号 1,2,3,...
    uint rid;

    //等待签署的应收款单据
    mapping(uint => Receipt) public pending;
    
    //公司到应收帐款的映射
    mapping(address => Receipt[]) public receipts;
    
    event ReceiptIssued(address SME, string desc);
    event ReceiptSigned(address core, string desc);
    event Transfered(address fromSME, address toSME, uint amount, string desc);
    event Loaned(address bank, address SME, uint amount, string desc);
    event pay(address core, address SME, uint amount, string desc);
    
    constructor() public {
        rid = 1;
    }

    function SetBank(string _name, address _ad, uint _amount) public returns(bool) {
        // require(_ad == msg.sender);
        bank = Bank(_ad, _name);
        balances[_ad] = _amount;
        return true;
    }

    function SetCore(string _name, address _ad, uint _amount) public returns(bool) {
        // require(_ad == msg.sender);
        companys[_ad] = Company(_ad, _name, true);
        balances[_ad] = _amount;
        return true;
    }

    function AddSME(string _name, address _ad, uint _amount) public returns(bool) {
        // require(_ad == msg.sender);
        companys[_ad] = Company(_ad, _name, false);
        balances[_ad] = _amount;
        return true;
    }
    
    //中小企业发起应收账款单据
    function IssueReceipt(address SME, address core, uint amount, uint timeInterval, string info) public returns(uint id_) {
        // require(SME == msg.sender);
        // require(companys[core].creditValues);
        pending[rid] = Receipt(rid, SME, core, amount, now, now+timeInterval, false, info);
        id_ = rid;
        rid++;
        emit ReceiptIssued(SME, "receipt Issued");
    }
    
    //核心企业签署应收账款单据
    function SignReceipt(address core, uint receiptID) public returns(bool) {
        Receipt r = pending[receiptID];
        //签署人必须是核心企业
        //require(companys[core].creditValues, "your don't have permission to sign this receipt.");
        require(companys[core].creditValues);
        //单据未到期
        require(now < r.end_date);
        //receipts[r.SME].push(Receipt(r.id, r.SME, r.core, r.amount, r.start_date, r.end_date, r.isLoan, r.info));
        receipts[r.SME].push(r);
        emit ReceiptIssued(core, "receipt signed");
        return true;
    }
    
    //中小企业转让应收账款
    function TransferTo(address from, uint receiptID, address to, uint amount) public returns(uint id_) {
        Receipt storage fromReceipt;
        uint len = receipts[from].length;
        for (uint i = 0; i < len; i++) {
            if (receipts[from][i].id == receiptID) {
                fromReceipt = receipts[from][i];
                break;
            }
            require(i != len-1, "no such receipt id.");
        }

        require(fromReceipt.amount >= amount && amount > 0);
        //转移账款
        fromReceipt.amount -= amount;
        receipts[to].push(Receipt(rid, to, core.ad, amount, now, fromReceipt.end_date, fromReceipt.isLoan, fromReceipt.info));
        id_ = rid;
        rid++;
        emit Transfered(from, to, amount, "transfer successfully");
    }
    
    function MakeLoan(address _bank, address loanTo, uint receiptID, uint loanAmount) public returns(bool) {
        //必须是银行发放贷款
        require(_bank == bank.ad, "Only the bank can make loan");
        
        //找到应收款单据
        Receipt storage r;
        uint i;
        uint len = receipts[loanTo].length;
        for (i = 0; i < len; i++) {
            if (receipts[loanTo][i].id == receiptID) {
                r = receipts[loanTo][i];
                break;
            }
            require(i != len-1, "no such receipt id.");
        }
        
        //true说明该单据已经被用来贷款了
        require(r.isLoan == false, "the receipt has been used for loan");
        require(r.amount >= loanAmount);
        require(companys[r.core].creditValues);
        
        r.isLoan = true;
        balances[bank.ad] -= loanAmount;
        balances[loanTo] += loanAmount;
        emit Loaned(_bank, loanTo, loanAmount, "loaned successfully.");
        return true;
    }
    
    function PayForReceipt(address core, address SME, uint amount, uint receiptID) public returns(bool) {
        Receipt storage r;
        uint i;
        uint len = receipts[SME].length;
        for (i = 0; i < len; i++) {
            if (receipts[SME][i].id == receiptID) {
                r = receipts[SME][i];
                break;
            }
            require(i != receipts[msg.sender].length - 1,"no such receipt id.");
        }
        
        require(r.core == msg.sender,"sender doesn't match receipt's client");
        require(r.amount >= amount,"payment exceeds receipt'amount");
        r.amount -= amount;
        balances[core] -= amount;
        balances[SME] += amount;
        if(r.amount > 0)
            return true;
        for(; i < len-1; i++) {
            receipts[SME][i] = receipts[SME][i+1];
        }
        delete receipts[SME][i];
        //receipts[owner].length--;
        emit pay(msg.sender, SME, amount, "pay for receipt successfully.");
        return true;
    }
    
}



