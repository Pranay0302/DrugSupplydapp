pragma solidity >=0.4.24;

import "../core/Ownable.sol";
import "./Utils.sol";

contract DrugSupplyChain is Utils, Ownable {

    address creator;

    uint upc;

    mapping (uint => Drug) drugs;

    mapping (uint => string[]) public drugsHistory;

    Drug[] discoveredDrugs;

    enum State
    {
        Discovered,  // 0
        Approved,  // 1
        Produced,     // 2
        ForWholeSale,    // 3
        ForRetail,       // 4
        ForSale,    // 5
        Sold   // 6
    }

    enum Role
    {
        PharmaCompany,  // 0
        MVO, // 1
        WholeSaleCompany,  // 2
        Pharmacy,     // 3
        Client    // 4
    }

    State constant defaultState = State.Discovered;

    struct Drug {
        uint upc; // Universal Product Code (UPC), generated by the pharma company, goes on the package, can be verified by the Client
        uint mvoCode; // generated by the MVO - unique code of the product batch
        address ownerID;  // Metamask-Ethereum address of the current owner as the product moves through 7 stages
        address originPharmaCompanyID; // Metamask-Ethereum address of the PharmaCompany
        string originPharmaName; // PharmaCompany Name
        string originPharmaInformation;  // PharmaCompany Information
        //string originPharmaPlantLatitude; // PharmaCompany Plant Latitude
        //string originPharmaPlantLongitude;  // PharmaCompany Plant Longitude
        bytes32 productID;  // Product ID potentially a combination of upc + sku
        string drugName;
        string activeIngredient; // API used in the drug
        string drugNotes; // Product Notes
        uint drugPrice; // Product Price
        State drugState;  // Product State as represented in the enum above
        uint timestamp;
        address MVOiD;  // Metamask-Ethereum address of the MVO
        address wholesalerID; // Metamask-Ethereum address of the WholeSaleCompany
        address pharmacyID; // Metamask-Ethereum address of the Pharmacy
        address clientID; // Metamask-Ethereum address of the Client
    }

    event Discovered(uint upc);
    event Approved(uint upc);
    event Produced(uint upc);
    event ForWholeSale(uint upc);
    event ForRetail(uint upc);
    event ForSale(uint upc);
    event Sold(uint upc);

    modifier onlyOwner() {
        require(msg.sender == creator);
        _;
    }

    modifier verifyCaller (address _address) {
        require(msg.sender == _address);
        _;
    }

    modifier paidEnough(uint _price) {
        require(msg.value >= _price);
        _;
    }

    modifier checkValue(uint _upc) {
        uint _price = drugs[_upc].drugPrice;
        uint amountToReturn = msg.value - _price;
        // drugs[_upc].consumerID.transfer(amountToReturn);
        msg.sender.transfer(amountToReturn);
        _;
    }

    modifier discovered(uint _upc) {
        require(drugs[_upc].drugState == State.Discovered);
        _;
    }

    modifier approved(uint _upc) {
        require(drugs[_upc].drugState == State.Approved);
        _;
    }

    modifier produced(uint _upc) {
        require(drugs[_upc].drugState == State.Produced);
        _;
    }

    modifier forWholeSale(uint _upc) {
        require(drugs[_upc].drugState == State.ForWholeSale);
        _;
    }

    modifier forRetail(uint _upc) {
        require(drugs[_upc].drugState == State.ForRetail);
        _;
    }

    modifier forSale(uint _upc) {
        require(drugs[_upc].drugState == State.ForSale);
      _;
    }

    // Define a modifier that checks if an item.state of a upc is Sold
    modifier sold(uint _upc) {
        require(drugs[_upc].drugState == State.Sold);
        _;
    }

    constructor() public payable {
        creator = msg.sender;
        //sku = 1;
        upc = 1;
    }

    // Define a function 'kill' if required
    function kill() public {
        if (msg.sender == creator) {
            selfdestruct(_makePayable(creator));
        }
    }

    // make an address payable
    function _makePayable(address x) private pure returns(address payable) {
        return address(uint160(x));
    }

    function currentRole(address account) public view returns(uint) {
        if (isPharmaCompany(account)) {
            // account is recorded as a pharmaCompany
            return 0;
        } else if (isMVO(account)) {
            // account is recorded as an MVO
            return 1;
        } else if (isWholeSaleCompany(account)) {
            // account is recorded as a wholeSaleCompany
            return 2;
        } else if (isPharmacy(account)) {
            // account is recorded as a pharmacy
            return 3;
        } else if (isClient(account)) {
            // account is recorded as a client
            return 4;
        } else {
            // no role assigned
            return 99;
        }
    }

    function signInAs(address _account, string memory _role) public {
        // no previous role must be assigned
        require(currentRole(_account) == 99);
        if (compareStrings(_role, "Pharmaceutical Company")) {
            addPharmaCompany(_account);
        } else if (compareStrings(_role, "MVO")) {
            addMVO(_account);
        } else if (compareStrings(_role, "Wholesale Company")) {
            addWholeSaleCompany(_account);
        } else if (compareStrings(_role, "Pharmacy")) {
            addPharmacy(_account);
        } else if (compareStrings(_role, "Client")) {
            addClient(_account);
        }
    }

    // define a function that will enable the frontend to modify the drug transaction history
    function setTxHistory(uint _upc, string memory _txHash) public {
        drugsHistory[_upc].push(_txHash);
    }

    // Define a function 'discoverDrug' that allows a farmer to mark an item 'Discovered'
    function discoverDrug(
        string memory _drugName,
        //address _originPharmaCompanyID,
        string memory _originPharmaName,
        string memory _originPharmaInformation,
        //string  memory _originPharmaPlantLatitude,
        //string  memory _originPharmaPlantLongitude,
        string memory _activeIngredient
    ) public onlyPharmaCompanies
    {
    // Add the new item
    require(!checkIfDrugExists(_drugName, _activeIngredient));
    //require(!checkIfDrugExists(_drugName));
    Drug memory newDrug = Drug({
        upc: upc,
        //sku: sku,
        mvoCode: 0,
        ownerID: msg.sender,
        originPharmaCompanyID: msg.sender,
        originPharmaName: _originPharmaName,
        originPharmaInformation: _originPharmaInformation,
        //originPharmaPlantLatitude: _originPharmaPlantLatitude,
        //originPharmaPlantLongitude: _originPharmaPlantLongitude,
        productID: "",
        drugName: _drugName,
        activeIngredient: _activeIngredient,
        drugNotes: "",
        drugPrice: 0,
        drugState: State.Discovered,
        timestamp: 0,
        MVOiD: address(0),
        wholesalerID: address(0),
        pharmacyID: address(0),
        clientID: address(0)
    });

    drugs[upc] = newDrug;
    storeHashedCoords(_drugName, _activeIngredient, upc);
    // Emit the appropriate event
    emit Discovered(upc);

    // increment upc
    upc = discoveredDrugs.push(newDrug) + 1;
    // update the owners history mapping
    // currentOwner = msg.sender;
    // ownersHistory[upc].push(currentOwner);
    }

    // Define a function 'addUniqueID' that allows an MVO to change the state of a drug to 'Approved'
    function addUniqueID(uint _upc) public discovered(_upc) onlyMVOs
    // Call modifier to check if upc has passed previous supply chain stage
    // Call modifier to verify caller of this function
    {
    // Update the appropriate fields
    Drug storage drugToUpdate = drugs[_upc];
    // add the mvo address
    drugToUpdate.MVOiD = msg.sender;


    string memory concatCoords = strConcat(drugToUpdate.originPharmaName, drugToUpdate.drugName, drugToUpdate.activeIngredient);
    // update the mvo code
    drugToUpdate.mvoCode = uint(keccak256(abi.encodePacked(concatCoords)));
    // update the state
    drugToUpdate.drugState = State.Approved;

    // Emit the appropriate event
    emit Approved(_upc);

    // update the owners history mapping
    /*ownersHistory[upc].push(currentOwner);*/

    }

    // Define a function 'produce Drug' that allows a pharmaCompany to change the state of the drug to 'Produced'
    function produceDrug(uint _upc, uint _price, string memory _drugNotes) public approved(_upc) onlyPharmaCompanies
    // Call modifier to check if upc has passed previous supply chain stage
    // Call modifier to verify caller of this function
    {
    // Update the appropriate fields
    Drug storage drugToUpdate = drugs[_upc];
    // only the discoverer can produce the drug
    require(drugToUpdate.ownerID == msg.sender);
    // update timestamp
    uint currentTime = now;
    drugToUpdate.timestamp = currentTime;

    drugToUpdate.productID = keccak256(abi.encodePacked(_upc + currentTime));
    drugToUpdate.drugPrice = _price;
    drugToUpdate.drugNotes = _drugNotes;

    // update the state

    drugToUpdate.drugState = State.Produced;
    // Emit the appropriate event
    emit Produced(_upc);
    // update the owners history mapping
    /*currentOwner = msg.sender;
    ownersHistory[upc].push(currentOwner);*/
    }

    // Define a function 'setForWholeSale' that allows a pharma company to change the state of the drug to "ForWholeSale"
    function setForWholeSale(uint _upc) public produced(_upc) onlyPharmaCompanies
    // Call modifier to check if upc has passed previous supply chain stage
    // Call modifier to verify caller of this function

    {
    // Update the appropriate fields
    Drug storage drugToUpdate = drugs[_upc];
    require(drugToUpdate.ownerID == msg.sender);
    //drugToUpdate.drugPrice = _price;
    drugToUpdate.drugState = State.ForWholeSale;
    // Emit the appropriate event
    emit ForWholeSale(_upc);
    }

    // define a function to enable buyig a drugName
    function buyDrugItem(uint _upc) public payable paidEnough(drugs[_upc].drugPrice) checkValue(_upc) {
        // Update the appropriate fields
        Drug storage drugToUpdate = drugs[_upc];
        require(currentRole(msg.sender) != 99);

        if (currentRole(msg.sender) == 2) {
            // if the sender is a wholesale company
            require(drugToUpdate.drugState == State.ForWholeSale);
            drugToUpdate.wholesalerID = msg.sender;
            drugToUpdate.drugState = State.ForRetail;
            emit ForRetail(_upc);
        } else if (currentRole(msg.sender) == 3) {
            // if the sender is a pharmacy
            require(drugToUpdate.drugState == State.ForRetail);
            drugToUpdate.pharmacyID = msg.sender;
            drugToUpdate.drugState = State.ForSale;
            emit ForSale(_upc);
        } else if (currentRole(msg.sender) == 4) {
            // if the sender is a private client
            require(drugToUpdate.drugState == State.ForSale);
            drugToUpdate.clientID = msg.sender;
            drugToUpdate.drugState = State.Sold;
            emit Sold(_upc);
        }
        /*// update the owners history mapping
        currentOwner = msg.sender;
        ownersHistory[_upc].push(currentOwner);*/
        address payable prevOwner = _makePayable(drugToUpdate.ownerID);
        drugToUpdate.ownerID = msg.sender;
        prevOwner.transfer(drugToUpdate.drugPrice);

    }

    function updatePrice(uint _upc, uint _newPrice) public {
        Drug storage drugToUpdate = drugs[_upc];
        require(currentRole(msg.sender) == 0 || currentRole(msg.sender) == 2 || currentRole(msg.sender) == 3);
        require(drugToUpdate.ownerID == msg.sender);
        drugToUpdate.drugPrice = _newPrice;
    }

  //}
    function howManyDrugs() public view returns(uint) {
        return discoveredDrugs.length;
    }

    function getTxHistoryLength(uint _upc) public view returns(uint) {
        return drugsHistory[_upc].length;
    }

    // Define a function 'fetchItemBufferOne' that fetches the data
    function fetchItemBufferOne(uint _upc) public view returns
    (
    uint univProdCode,
    uint mvoCode,
    address ownerID,
    address originPharmaCompanyID,
    string memory originPharmaName,
    string memory originPharmaInformation,
    string memory drugName
    )
    {
    // Assign values to the parameters
    Drug memory drugToUpdate = drugs[_upc];

    univProdCode = _upc;
    mvoCode = drugToUpdate.mvoCode;
    ownerID = drugToUpdate.ownerID;
    originPharmaCompanyID = drugToUpdate.originPharmaCompanyID;
    originPharmaName = drugToUpdate.originPharmaName;
    originPharmaInformation = drugToUpdate.originPharmaInformation;
    drugName = drugToUpdate.drugName;

    return (univProdCode, mvoCode, ownerID, originPharmaCompanyID, originPharmaName, originPharmaInformation, drugName);
    }

    // Define a function 'fetchItemBufferTwo' that fetches the data
    function fetchItemBufferTwo(uint _upc) public view returns
    (
    uint univProdCode,
    bytes32 productID,
    string memory drugNotes,
    uint drugPrice,
    State drugState,
    address MVOiD,
    address wholesalerID,
    address pharmacyID,
    address clientID
    )
    {
    // Assign values to the parameters
    Drug memory drugToUpdate = drugs[_upc];

    productID = drugToUpdate.productID;
    drugNotes = drugToUpdate.drugNotes;
    univProdCode = _upc;
    drugPrice = drugToUpdate.drugPrice;
    drugState = drugToUpdate.drugState;
    MVOiD = drugToUpdate.MVOiD;
    wholesalerID = drugToUpdate.wholesalerID;
    pharmacyID = drugToUpdate.pharmacyID;
    clientID = drugToUpdate.clientID;

    return (univProdCode, productID, drugNotes, drugPrice, drugState, MVOiD, wholesalerID, pharmacyID, clientID);
    }
}
