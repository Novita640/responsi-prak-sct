// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DrugAuthenticity {

    // ======================================================
    // ENUM STATUS OBAT
    // ======================================================

    enum DrugStatus {
        Produced,
        Distributed,
        Pharmacy,
        Sold
    }

    // ======================================================
    // STRUKTUR DATA
    // ======================================================

    struct Drug {

        string drugID;          // ID unik obat
        string drugName;        // Nama obat
        string manufacturer;    // Nama pabrik
        string batchNumber;     // Nomor batch
        uint256 productionDate; // Timestamp produksi

        DrugStatus status;

        bool exists;
    }

    // ======================================================
    // OWNER (PABRIK)
    // ======================================================

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only manufacturer");
        _;
    }

    // ======================================================
    // STORAGE
    // ======================================================

    mapping(string => Drug) private drugs;

    // ======================================================
    // EVENTS
    // ======================================================

    event DrugRegistered(
        string drugID,
        string drugName,
        string manufacturer
    );

    event StatusUpdated(
        string drugID,
        DrugStatus newStatus
    );

    // ======================================================
    // REGISTER OBAT
    // ======================================================

    function registerDrug(
        string memory _drugID,
        string memory _drugName,
        string memory _manufacturer,
        string memory _batchNumber
    ) public onlyOwner {

        require(!drugs[_drugID].exists, "Drug ID already exists");

        drugs[_drugID] = Drug({
            drugID: _drugID,
            drugName: _drugName,
            manufacturer: _manufacturer,
            batchNumber: _batchNumber,
            productionDate: block.timestamp,
            status: DrugStatus.Produced,
            exists: true
        });

        emit DrugRegistered(
            _drugID,
            _drugName,
            _manufacturer
        );
    }

    // ======================================================
    // UPDATE STATUS
    // ======================================================

    function updateStatus(
        string memory _drugID,
        DrugStatus _status
    ) public onlyOwner {

        require(drugs[_drugID].exists, "Drug not found");

        drugs[_drugID].status = _status;

        emit StatusUpdated(
            _drugID,
            _status
        );
    }

    // ======================================================
    // CEK KEASLIAN
    // ======================================================

    function verifyDrug(
        string memory _drugID
    )
        public
        view
        returns(
            bool authentic,
            string memory drugName,
            string memory manufacturer,
            string memory batchNumber,
            uint256 productionDate,
            DrugStatus status
        )
    {

        if(!drugs[_drugID].exists){

            return(
                false,
                "",
                "",
                "",
                0,
                DrugStatus.Produced
            );

        }

        Drug memory d = drugs[_drugID];

        return(
            true,
            d.drugName,
            d.manufacturer,
            d.batchNumber,
            d.productionDate,
            d.status
        );
    }

    // ======================================================
    // DETAIL OBAT
    // ======================================================

    function getDrug(
        string memory _drugID
    )
        public
        view
        returns(Drug memory)
    {
        require(drugs[_drugID].exists, "Drug not found");

        return drugs[_drugID];
    }

}