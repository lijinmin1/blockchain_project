var http = require('http');
var url = require('url');
var exec = require('child_process').exec;

var path = '../nodejs-sdk/packages/cli/cli.js';
var callPath = null;

var contractAddress = null;
var bankAddress = null;
var coreAddress = null;
var SME1Address = null;
var SME2Address = null;

init();

http.createServer(function (request, response) {


}).listen(8080);

console.log('Server running at http://127.0.0.1:8080/');

function init() {
    //set xxxAddress
    deploy();
}

function deploy() {
    
    cmd = path + ' deploy Supplychain';
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        contractAddress = result.contractAddress;
        callPath = path + ' call Supplychain ' + contractAddress;
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function setBank(name, address) {

    cmd = callPath + ' SetBank ' + name + ' ' + address;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function setCore(name, address, amount) {

    cmd = callPath + ' SetCore ' + name + ' ' + address + ' ' + amount;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function addSME(name, address, amount) {

    cmd = callPath + ' AddSME ' + name + ' ' + address + ' ' + amount;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function issueReceipt(SME, core, amount, time, info) {

    cmd = callPath + ' IssueReceipt ' + SME + ' ' + core + ' ' + amount + ' ' + time + ' ' + info;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function signReceipt(core, receiptID) {

    cmd = callPath + ' SignReceipt ' + core + ' ' + receiptID;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function transferTo(from, receiptID, to, amount) {

    cmd = callPath + ' TransferTo ' + from + ' ' + receiptID + ' ' + to + ' ' + amount;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function makeLoan(bank, loanTo, receiptID, loanAmount) {

    cmd = callPath + ' MakeLoan ' + bank + ' ' + loanTo + ' ' + receiptID + ' ' + loanAmount;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function payForReceipt(core, SME, receiptID, amount) {

    cmd = callPath + ' PayForReceipt ' + core + ' ' + SME + ' ' + receiptID + ' ' + amount;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function getBank() {

    cmd = callPath + ' bank';
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function getCompanys(companyAddress) {

    cmd = callPath + ' companys ' + companyAddress;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function getBalances(companyAddress) {

    cmd = callPath + ' balances ' + companyAddress;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });
}

function getPending(receiptID) {

    cmd = callPath + ' pending ' + receiptID;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });

}

function getReceipts(companyAddress, id) {

    cmd = callPath + ' receipts ' + companyAddress + ' ' + id;
    
    exec(cmd,
    function (error, stdout, stderr) {
        result = JSON.parse(stdout);
        console.log(result);
        
        if (error !== null) {
             console.log('exec error: ' + error);
        }
    });

}
