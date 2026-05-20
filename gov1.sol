pragma solidity ^0.8.20;

// Funds are held in escrow and released in stages
// Each milestone requires TWO authorised signatures
// site inspector + supervising engineer before
// payment is unlocked for the contractor
// Citizen reports can freeze a milestone and trigger
// an audit hold, blocking further payments.

contract gov{

    // ---- Roles -----
    address public ghmc;
    address public contractor;
    address public inspector; //site inspector 
    address public engineer; // supervising engineer
    address public auditor; // independent auditor in case of disputes

    // ---- Contract Metadata ---
    string public contractId;
    string public description;
    string public wardName;

    // ----Milestone structure -------
    struct Milestone {
        string name; //what type of work to be done
        string description;
        uint256 amount; //amount of money required
        uint8 state; // 0 = locked 1=in progress 2= inspectorsigned 3=released 4 = disputed
        bool inspectorSigned;
        bool engineerSigned;
        string ipfsReportHash; //geotagged photo
        uint256 releasedAt; //timestamp of payment released
        uint256 disputedAt; //timestamp of dispute
    }

    Milestone[] public milestones;
    uint8 public activeMilestone;

    // -- quality hold?? ---
    uint256 public qualityHoldDuration = 90 days;
    uint256 public completionTime;
    bool public qualityHoldReleased;

    // ----citizen reports----
    struct CitizenReport{
        address reporter;
        string description;
        uint256 timestamp;
        bool resolved;
    }

    CitizenReport[] public citizenReports;
    uint8 public openReportCount;
    bool public paymentsFrozen; //dunno what this is for yet

    uint8 constant REPORT_THRESHOLD = 2 // dunno what this is for yet

    // ----- events ---- (visible on public blockchain explorer)
    event ContractFunded(uint256 totalAmount, uint256 timestamp);
    event MilestoneStarted(uint indexed milestoneIndex, string name);
    event InspectorSigned(uint indexed milestoneIndex, string ipfsHash);
    event EngineerSigned(uint indexed milestoneIndex)
    event MilestoneReleased(uint indexed milestoneIndex, uint amount, address contractor);
    event CitizenReportFiled(address indexed reporter, uint8 indexed milestone, string description);
    //dont really understand these events
    event PaymentsFrozen(uint8 openReports);
    event PaymentsUnfrozen(address auditor); 
    event DisputeResolved(uint8 indexed milestoneIndex, bool contractorPaid);
    event QualityHoldReleased(uint256 amount);

    // ---- modifiers ----
    modifier onlyGHMC() {require(msg.sender == ghmc, "only ghmc"); _;}
    modifier onlyInspector() {require(msg.sender == inspector, "only inspector"); _;}
    modifier onlyEngineer() {require(msg.sender == engineer, "only engineer"); _;}
    modifier onlyAuditor() {require(msg.sender == auditor, "only auditor"); _;}
    modifier notFrozen() {require(!paymentsFrozen, "payments frozen, audit pending"); _;}

    constructor(
        string memory _contractId,
        string memory _description,
        string memory _wardName,
    

    )


















}