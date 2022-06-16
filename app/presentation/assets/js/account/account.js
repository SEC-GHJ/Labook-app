console.log('account.js loaded');
$('#account-edit-bt').click(function(){
    let accept_mail_bt = $('#accept-mail-bt').attr('disabled');
    let public_profile_bt = $('#public-profile-bt').attr('disabled');
    let account_save_bt = $('#account-save-bt').attr('hidden');
    $('#accept-mail-bt').attr('disabled', !accept_mail_bt);
    $('#public-profile-bt').attr('disabled', !public_profile_bt);
    $('#account-save-bt').attr('hidden', !account_save_bt);
});