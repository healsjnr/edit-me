String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
};

function renderDate(dateString) {
    return moment(dateString).local().format("MMMM Do YYYY HH:mm");
}
