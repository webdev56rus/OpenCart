<?php echo $header; ?>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
    <?php if(isset($message)): ?>
        <div class="success"><?php echo $message; ?></div>
    <?php endif; ?>
  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/module.png" alt="" /> <?php echo $heading_title; ?></h1>
      <div class="buttons">
          <form action="" method="post">
            <a class="button" id="create_links"><?php echo $create_links; ?></a>
            <input type="hidden" name="create_links">
          </form>
        </div>
    </div>
    <div class="content">
        <h2><?php echo $create_rule; ?></h2>
        <form action="" method="post" id="rule">
        <!--<table id="module" class="list">
          <thead>
            <tr style="background-color: rgb(244, 244, 248);">
              <td class="left"><?php echo $category_title; ?></td>
              <td class="left"><?php echo $parent_category; ?></td>
              <td class="left"><?php echo $second_category; ?></td>
            </tr>
          </thead>
          <tbody id="module-row0">
            <tr>
                <td class="left">
                    <select name="category">
                        <option value="0"><?php echo $no_select; ?></option>
                        <?php foreach($categories as $category): ?>
                        <option value="<?php echo $category['category_id'] ?>"><?php echo $category['name'] ?></option>
                        <?php endforeach; ?>
                    </select>
                </td>
                <td class="left">
                    <select name="parent_category">
                        <option value="0"><?php echo $no_select; ?></option>
                        <?php foreach($categories as $category): ?>
                        <option value="<?php echo $category['category_id'] ?>"><?php echo $category['name'] ?></option>
                        <?php endforeach; ?>
                    </select>
                </td>
                <td class="left">
                    <select name="second_category">
                        <option value="0"><?php echo $no_select; ?></option>
                        <?php foreach($categories as $category): ?>
                        <option value="<?php echo $category['category_id'] ?>"><?php echo $category['name'] ?></option>
                        <?php endforeach; ?>
                    </select>
                </td>
            </tr>
          </tbody>
            <tfooter>
                <tr>
                    <td colspan="1"></td>
                    <td><div class="buttons"><a class="button" id="save"><?php echo $save_rule; ?></a></div></td>
                </tr>
            </tfooter>
        </table>-->
            
        <table id="module" class="list">
          <thead>
            <tr style="background-color: rgb(244, 244, 248);">
              <td class="left"><?php echo $category_title; ?></td>
              <td class="left"><?php echo $second_category; ?></td>
            </tr>
          </thead>
          <tbody id="module-row0">
            <tr>
                <td class="left">
                    <div class="scrollbox" id="category">
                        <?php foreach($categories as $category): ?>                                  
                            <div class="even"><input type="radio" name="category" value="<?php echo $category['category_id'] ?>"><?php echo $category['name'] ?></div>        
                        <?php endforeach; ?>
                    </div>
                </td>
                <td class="left">
                    <div class="scrollbox" id="second_category">
                        <?php foreach($categories as $category): ?>                                  
                            <div class="even"><input type="checkbox" value="<?php echo $category['category_id'] ?>"><?php echo $category['name'] ?></div>      
                        <?php endforeach; ?>
                    </div>
                </td>
            </tr>
          </tbody>
            <tfooter>
                <tr>
                    <td colspan="1"></td>
                    <td><div class="buttons"><a class="button" id="save"><?php echo $save_rule; ?></a></div></td>
                </tr>
            </tfooter>
        </table>
        </form>
        
        
            <h2><?php echo $load_rules; ?></h2>
              <?php if(isset($rules)): ?>
                <table id="module" class="list">
                    <thead>
                        <tr style="background-color: rgb(244, 244, 248);">
                            <td class="left"><?php echo $category_title; ?></td>
                            <!--<td class="left"><?php echo $parent_category; ?></td>-->
                            <td class="left"><?php echo $name_category; ?></td>
                            <td class="left"><?php echo $second_category; ?></td>
                            <td></td>
                        </tr>
                    </thead>
                    <tbody id="module-row0">
                    <?php foreach($rules as $rule): ?>
                    <tr>
                        <td class="left"><?php echo $rule['category']; ?></td>
                        <!--<td class="left"><?php echo $rule['parent_category']; ?></td>-->
                        <td class="left"><?php echo $rule['name']; ?></td>
                        <td class="left"><?php echo $rule['second_category']; ?></td>
                        <td class="left"><a href="" class="delete" id="<?php echo $rule['id']; ?>"><?php echo $delete; ?></a></td>
                    </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
              <?php else: ?>
                    <div class="warning"><?php echo $not_have_rules; ?></div>
              <?php endif; ?>
        
        <form action="" method="post" id="delete">
            <input type="hidden" value="" name="delete_item">
        </form>
    </div>
  </div>
</div>


<script>
$(document).ready(function(){
    $('#save').click(function(){
        var error = false;
        var url = document.location.href;
        var category = $('#category input:checked').val();
        var second_category = [];
        $.each($('#second_category input:checked'), function(){
            second_category.push($(this).val());
        });
        if(category == undefined)
        {
            alert('<?php echo $no_select_category ?>');   
            error = true;
        }
        if(second_category.length<=0)
        {
            error = true;
            alert('<?php echo $no_select_sec_category ?>');   
        }
        
        second_category = second_category.join(',');
        if(error == false)
        {
            $.ajax({
                url:url,
                type:'post',
                dataType:'text',
                data:'category='+category+'&second_category='+second_category,
                success:function(res){
                    location.reload();
                }
            });
        }
        return false;
    });
    
    $('#create_links').click(function(){
        $(this).closest('form').submit();
    });
    
    $('.delete').click(function(){
        var id = $(this).attr('id');
        $(this).closest('tr').slideDown(300).remove();
        var url = document.location.href;
        $.ajax({
            url:url,
            type:'post',
            dataType:'text',
            data:'delete_item='+id
        });
        return false;
    });
});
</script>
<?php echo $footer; ?>