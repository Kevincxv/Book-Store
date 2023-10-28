document.addEventListener('DOMContentLoaded', function() {
    var deleteButtons = document.querySelectorAll('.btn-danger');
    deleteButtons.forEach(function(button) {
        button.addEventListener('click', function(e) {
            if (!confirm('Are you sure you want to delete this book?')) {
                e.preventDefault();
            }
        });
    });
});
