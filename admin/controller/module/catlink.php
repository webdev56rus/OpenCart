<?php
class ControllerModuleCatlink extends Controller {
	private $error = array(); 

	public function index() {   
		$this->load->language('module/CatLink');
		$this->document->setTitle($this->language->get('heading_title'));
		$this->load->model('setting/setting');
        
        
        if(isset($this->request->post['create_links']))
        {
            $this->update_links();
            $this->data['message'] = $this->language->get('updated');
        }
        
        
        
        
        //Сохранаяем правило привязок
        if(isset($this->request->post['category']))
        {
            $this->save_rule();
            $this->data['message'] = $this->language->get('created_rule');
        }
        
        
        
        //Получаем категории 
        $this->load->model('catalog/category');

        $this->data['categories'] = array();

        foreach ($this->model_catalog_category->getCategories(array()) as $category) {
            $this->data['categories'][] = array(
                'category_id' => $category['category_id'],
                'name'        => $category['name']
            );
        }
        
        
        
        //Получаем существующие правила привязок
        $query = $this->db->query("SELECT * FROM ".DB_PREFIX."category_rules ORDER BY id DESC");
        $count = 0;
        foreach($query->rows as $row)
        {
            $category = $this->db->query("SELECT * FROM ".DB_PREFIX."category_description WHERE category_id='".$row['category_id']."' LIMIT 1");
            $parent_category = $this->db->query("SELECT * FROM ".DB_PREFIX."category_description WHERE category_id='".$row['parent_category_id']."' LIMIT 1");
            $second_category = $this->db->query("SELECT * FROM ".DB_PREFIX."category_description WHERE category_id='".$row['second_category_id']."' LIMIT 1");
            $category = $category->row['name'];
            if(isset($parent_category->row['name']))
                $parent_category = $parent_category->row['name'];
            else
                $parent_category = ' ';
            $second_category = $second_category->row['name'];
            $categories = array('category' => $category, 'parent_category' => $parent_category, 'second_category' => $second_category, 'name' => $row['name']);
            $data[$count] = $categories;
            $count++;
        }
        
        $this->data['rules'] = $data;

        
        //Заголовки и ошибки
        
		$this->data['heading_title'] = $this->language->get('heading_title');
        $this->data['create_links'] = $this->language->get('create_links'); 
        $this->data['save_rule'] = $this->language->get('save_rule');
        
        $this->data['created_rule'] = $this->language->get('created_rule');
        
        $this->data['create_rule'] = $this->language->get('create_rule');
        $this->data['load_rules'] = $this->language->get('load_rules');

        $this->data['category'] = $this->language->get('category');
        $this->data['parent_category'] = $this->language->get('parent_category');
        $this->data['second_category'] = $this->language->get('second_category');
        $this->data['name_category'] = $this->language->get('name_category');
        $this->data['no_select'] = $this->language->get('no_select');

 		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}
        
        
        //Хлебные крошки

  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_module'),
			'href'      => $this->url->link('extension/module', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('module/myModul', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => ' :: '
   		);

		
        //Шаблон админки
		$this->load->model('design/layout');

		$this->data['layouts'] = $this->model_design_layout->getLayouts();

		$this->template = 'module/CatLink.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);				
		$this->response->setOutput($this->render());
	}
    
    private function save_rule()    //Сохраняем привязку
    {
        if(isset($this->request->post['category']))
            $category = $this->request->post['category'];
        if(isset($this->request->post['parent_category']))
            $parent_category = $this->request->post['parent_category'];
        if(isset($this->request->post['second_category']))
            $second_category = $this->request->post['second_category'];
        $query = $this->db->query("SELECT * FROM ".DB_PREFIX."category_description WHERE category_id='".$category."' LIMIT 1");
        $category_name = $query->row['name'];
        $query = $this->db->query("SELECT * FROM ".DB_PREFIX."category_description WHERE category_id='".$parent_category."' LIMIT 1");
        if(count($query->row) > 0)
            $parent_category_name = $query->row['name'];
        $query = $this->db->query("SELECT * FROM ".DB_PREFIX."category_description WHERE category_id='".$second_category."' LIMIT 1");
        if(count($query->row) > 0)
            $second_category_name = $query->row['name'];
        $name = $parent_category_name.'/'.$category_name.','.$second_category_name;
        $query = $this->db->query("INSERT INTO ".DB_PREFIX."category_rules (`id`, `category_id`, `parent_category_id`, `name`, `second_category_id`) VALUES (NULL, $category, $parent_category, '".$name."', $second_category)"); 
    }
    
    
    private function update_links() //Обновляем привязки товаров по категориям
    {
        $query = $this->db->query("SELECT * FROM ".DB_PREFIX."category_rules ORDER BY id DESC");
        foreach($query->rows as $rule)
        {
            $products = $this->db->query("SELECT * FROM ".DB_PREFIX."product_to_category WHERE category_id = ".$rule['category_id']);
            $products_sec = $this->db->query("SELECT * FROM ".DB_PREFIX."product_to_category WHERE category_id = ".$rule['second_category_id']);
            foreach($products->rows as $first_cat_product)
            {
                $key = false;
                foreach($products_sec->rows as $second_cat_product)
                {
                    if(($first_cat_product['category_id'] == $rule['category_id']) and ($second_cat_product['category_id'] == $rule['second_category_id']))
                    {
                        
                        $key = true;
                        break;
                    }
                }
                
                if($key == false)
                {
                    echo $rule['second_category_id'];
                    $query = $this->db->query("INSERT INTO ".DB_PREFIX."product_to_category (`product_id`, `category_id`, `main_category`) VALUES(".$second_cat_product['product_id'].", ".$rule['second_category_id'].", ".$rule['parent_category_id'].")");
                }
            }
        }
    }

	private function validate() {
		if (!$this->user->hasPermission('modify', 'module/catlink')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if (!$this->error) {
			return true;
		} else {
			return false;
		}	
	}
}
?>