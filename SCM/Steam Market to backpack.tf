// ==UserScript==
// @name         Steam Market to backpack.tf
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Add a button to navigate from Steam Market to backpack.tf for specific items
// @author       16546489
// @match        https://steamcommunity.com/market/listings/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // Function to get the item name from the URL
    function getItemNameFromURL() {
        // Get the last part of the URL after the last slash
        let urlParts = window.location.href.split('/');
        let itemName = decodeURIComponent(urlParts[urlParts.length - 1]);
        // Replace %20 with spaces and %27 with apostrophes
        itemName = itemName.replace(/%20/g, ' ').replace(/%27/g, "'");
        return itemName;
    }

    // Function to remove specific word from item name
    function removeSpecificWord(itemName, word) {
        return itemName.replace(new RegExp('\\b' + word + '\\b', 'ig'), '').trim();
    }

    // Function to handle button click
    function onButtonClick(event) {
        let itemName = getItemNameFromURL();
        // Remove specific word "Unusual" from item name
        itemName = removeSpecificWord(itemName, 'Unusual');
        // Construct the URL for backpack.tf
        let url = `https://backpack.tf/classifieds?item=${encodeURIComponent(itemName)}&quality=5`;
        // Open the URL in a new tab
        window.open(url, '_blank');
        // Prevent default action (e.g., following a link)
        event.preventDefault();
    }

    // Function to add the button
    function addButton() {
        let button = document.createElement('button');
        button.innerText = 'Go to backpack.tf';
        button.style.marginTop = '10px';
        button.addEventListener('click', onButtonClick);
        // Allow middle mouse button click to open in a new tab
        button.addEventListener('mousedown', function(event) {
            if (event.button === 1) { // Check if it's the middle mouse button
                onButtonClick(event);
            }
        });
        let marketActions = document.querySelector('.market_listing_right_cell.market_listing_action_buttons');
        marketActions.appendChild(button);
    }

    // Wait for the page to fully load before adding the button
    window.addEventListener('load', function() {
        setTimeout(addButton, 3000); // Add a delay of 3 seconds
    });
})();
