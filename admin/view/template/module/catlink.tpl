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
        <table id="module" class="list">
          <thead>
            <tr style="background-color: rgb(244, 244, 248);">
              <td class="left"><?php echo $category; ?></td>
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
                    <td colspan="2"></td>
                    <td><div class="buttons"><a class="button" id="save"><?php echo $save_rule; ?></a></div></td>
                </tr>
            </tfooter>
        </table>
        </form>
        
        
        <h2><?php echo $load_rules; ?></h2>
        <table id="module" class="list">
          <thead>
            <tr style="background-color: rgb(244, 244, 248);">
              <td class="left"><?php echo $category; ?></td>
              <td class="left"><?php echo $parent_category; ?></td>
              <td class="left"><?php echo $name_category; ?></td>
              <td class="left"><?php echo $second_category; ?></td>
            </tr>
          </thead>
          <tbody id="module-row0">
                <?php foreach($rules as $rule): ?>
                    <tr>
                      <td class="left"><?php echo $rule['category']; ?></td>
                      <td class="left"><?php echo $rule['parent_category']; ?></td>
                      <td class="left"><?php echo $rule['name']; ?></td>
                      <td class="left"><?php echo $rule['second_category']; ?></td>
                    </tr>
                <?php endforeach; ?>
          </tbody>
        </table>
        
    </div>
  </div>
</div>


<script>
$(document).ready(function(){
    $('#save').click(function(){
        $('#rule').submit();
    });
    
    $('#create_links').click(function(){
        $(this).closest('form').submit();
    });
});
</script>
<?php echo $footer; ?>