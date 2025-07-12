// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract MockV3Aggregator is AggregatorV3Interface {
    uint256 public constant version = 4;

    uint8 public decimals;
    int256 public _price;
    uint256 public _timestamp;
    uint80 public _roundId;
    string public description;

    constructor(uint8 _decimals, int256 _initialPrice) {
        decimals = _decimals;
        _price = _initialPrice;
        _timestamp = block.timestamp;
        _roundId = 1;
        description = "Mock V3 Aggregator";
    }

    function getRoundData(
        uint80 _id
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (_id, _price, _timestamp, _timestamp, _id);
    }

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (_roundId, _price, _timestamp, _timestamp, _roundId);
    }

    function updatePrice(int256 _newPrice) external {
        _price = _newPrice;
        _timestamp = block.timestamp;
        _roundId++;
    }
} 