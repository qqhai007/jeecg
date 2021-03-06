<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>${ftl_description}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name=viewportcontent="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no,minimal-ui">
	<link rel="stylesheet" href="https://unpkg.com/element-ui@2.3.7/lib/theme-chalk/index.css">
	<script src="https://unpkg.com/vue/dist/vue.js"></script>
	<script src="https://cdn.bootcss.com/vue-resource/1.5.0/vue-resource.js"></script>  
	<script src="https://unpkg.com/element-ui@2.3.7/lib/index.js"></script>
	<style>
	.toolbar {
	    padding: 10px;
	    margin: 10px 0;
	}
	.toolbar .el-form-item {
	    margin-bottom: 10px;
	}
	[v-cloak] { display: none }
	</style>
</head>
<body style="background-color: #FFFFFF;">
	<div id="${entityName?uncap_first}List" v-cloak>
		<!--工具条-->
		<el-row>
			<el-form :inline="true" :model="filters" size="mini" ref="filters">
			<#list columns as po>
		 	<#if po.isQuery =='Y' >
			<#if po.showType=='text'>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}">
					<el-input v-model="filters.${po.fieldName}" auto-complete="off" placeholder="请输入${po.content}"></el-input>
				</el-form-item>
			<#elseif po.showType=='textarea'>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}">
					<el-input type="textarea" v-model="filters.${po.fieldName}"></el-input>
				</el-form-item>
			<#elseif po.showType=='password'>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}">
					<el-input type="password" v-model="filters.${po.fieldName}"></el-input>
				</el-form-item>
			<#elseif po.showType=='date'>
				<#if po.queryMode=='group'>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}_begin">
					<el-date-picker type="date" placeholder="选择${po.content}开始" v-model="filters.${po.fieldName}_begin"></el-date-picker>
				</el-form-item>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}_end">
					<el-date-picker type="date" placeholder="选择${po.content}结束" v-model="filters.${po.fieldName}_end"></el-date-picker>
				</el-form-item>
				<#else>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}">
					<el-date-picker type="date" placeholder="选择${po.content}" v-model="filters.${po.fieldName}"></el-date-picker>
				</el-form-item>
				</#if>
			<#elseif po.showType=='datetime'>
				<#if po.queryMode=='group'>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}_begin">
					 <el-date-picker type="datetime" placeholder="选择${po.content}开始" v-model="filters.${po.fieldName}_begin"></el-date-picker>
				</el-form-item>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}_end">
					 <el-date-picker type="datetime" placeholder="选择${po.content}结束" v-model="filters.${po.fieldName}_end"></el-date-picker>
				</el-form-item>
				<#else>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}">
					 <el-date-picker type="datetime" placeholder="选择${po.content}" v-model="filters.${po.fieldName}"></el-date-picker>
				</el-form-item>
				</#if>
			<#elseif po.showType=='checkbox'>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}">
				    <el-select v-model="filters.${po.fieldName}" multiple placeholder="请选择${po.content}">
				      <el-option :label="option.typename" :value="option.typecode" v-for="option in ${po.dictField}Options"></el-option>
				    </el-select>
				</el-form-item>
			<#elseif po.showType=='select' || po.showType=='list' || po.showType=='radio'>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}">
					<el-select v-model="filters.${po.fieldName}" placeholder="请选择${po.content}">
				      <el-option :label="option.typename" :value="option.typecode" v-for="option in ${po.dictField}Options"></el-option>
				    </el-select>
				</el-form-item>
			<#else>
				<el-form-item style="margin-bottom: 8px;" prop="${po.fieldName}">
					<el-input v-model="filters.${po.fieldName}" auto-complete="off" placeholder="请输入${po.content}"></el-input>
				</el-form-item>
			</#if>
		 	</#if>
			</#list>
				<el-form-item>
			    	<el-button type="primary" icon="el-icon-search" v-on:click="get${entityName?cap_first}s">查询</el-button>
			    </el-form-item>
			    <el-form-item>
			    	<el-button icon="el-icon-refresh" @click="resetForm('filters')">重置</el-button>
			    </el-form-item>
			    <el-form-item>
			    	<el-button type="primary" icon="el-icon-edit" @click="handleAdd">新增</el-button>
			    </el-form-item>
			</el-form>
		</el-row>
		
		<!--列表-->
		<el-table :data="${entityName?uncap_first}s" border stripe size="mini" highlight-current-row v-loading="listLoading" @sort-change="handleSortChange"  @selection-change="selsChange" style="width: 100%;">
			<el-table-column type="selection" width="55"></el-table-column>
			<el-table-column type="index" width="60"></el-table-column>
			<#list columns as po><#rt/>
			<#if po.isShowList?if_exists?html !='N'><#rt/>
			<#if po.showType=='file' || po.showType == 'image'>
			<el-table-column prop="${po.fieldName}" label="${po.content}" min-width="${po.fieldLength}" sortable="custom" show-overflow-tooltip>
				<template slot-scope="scope" v-if="scope.row.${po.fieldName}">
					<el-button size="mini" type="primary" @click="handleDownFile('1',scope.row.${po.fieldName})">文件下载</el-button>
				</template>
			</el-table-column>
			<#else>
			<el-table-column prop="${po.fieldName}" label="${po.content}" min-width="${po.fieldLength}" sortable="custom" show-overflow-tooltip<#if po.showType?index_of("datetime")!=-1> :formatter="formatDateTime"<#rt />
			<#elseif po.showType?index_of("date")!=-1> :formatter="formatDate"<#elseif po.showType=='select' || po.showType=='list'  || po.showType=='checkbox' || po.showType=='radio'> :formatter="format${po.dictField?cap_first}Dict"</#if>></el-table-column>
			</#if>
			</#if>
			</#list>
			<el-table-column label="操作" width="150">
				<template scope="scope">
					<el-button size="mini" @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
					<el-button type="danger" size="mini" @click="handleDel(scope.$index, scope.row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		
		<!--工具条-->
		<el-col :span="24" class="toolbar">
			<el-button type="danger" size="mini" @click="batchRemove" :disabled="this.sels.length===0">批量删除</el-button>
			 <el-pagination small background @current-change="handleCurrentChange" @size-change="handleSizeChange" :page-sizes="[10, 20, 50, 100]"
      			:page-size="pageSize" :total="total" layout="sizes, prev, pager, next"  style="float:right;"></el-pagination>
		</el-col>
		
		<!--编辑界面-->
		<el-dialog title="编辑" fullscreen :visible.sync="editFormVisible" :close-on-click-modal="false">
			<el-form :model="addForm" label-width="80px" :rules="addFormRules" ref="addForm" size="mini">
				<#list pageColumns as po>
				<#if po.showType=='text'>
					<el-form-item label="${po.content}" prop="${po.fieldName}">
						<el-input v-model="addForm.${po.fieldName}" auto-complete="off" placeholder="请输入${po.content}"></el-input>
					</el-form-item>
				<#elseif po.showType=='textarea'>
					<el-form-item label="${po.content}">
						<el-input type="textarea" v-model="addForm.${po.fieldName}"></el-input>
					</el-form-item>
				<#elseif po.showType=='password'>
					<el-form-item label="${po.content}">
						<el-input type="password" v-model="addForm.${po.fieldName}"></el-input>
					</el-form-item>
				<#elseif po.showType=='date'>
					<el-form-item label="${po.content}">
						<el-date-picker type="date" placeholder="选择${po.content}" v-model="addForm.${po.fieldName}"></el-date-picker>
					</el-form-item>
				<#elseif po.showType=='datetime'>
					<el-form-item label="${po.content}">
						 <el-date-picker type="datetime" placeholder="选择${po.content}" v-model="addForm.${po.fieldName}"></el-date-picker>
					</el-form-item>
				<#elseif po.showType=='checkbox'>
					<el-form-item label="${po.content}">
					    <el-select v-model="addForm.${po.fieldName}" multiple placeholder="请选择${po.content}">
					      <el-option :label="option.typename" :value="option.typecode" v-for="option in ${po.dictField}Options"></el-option>
					    </el-select>
					</el-form-item>
				<#elseif po.showType=='select' || po.showType=='list' || po.showType=='radio'>
					<el-form-item label="${po.content}">
						<el-select v-model="addForm.${po.fieldName}" placeholder="请选择${po.content}">
					      <el-option :label="option.typename" :value="option.typecode" v-for="option in ${po.dictField}Options"></el-option>
					    </el-select>
					</el-form-item>
				<#elseif po.showType=='file' || po.showType == 'image'>
					<el-form-item label="${po.content}" prop="${po.fieldName}">
						<el-upload
						  :action="url.upload"
						  :data="{isup:'1'}"
						  :on-success="handle${po.fieldName?cap_first}UploadFile"
						  :on-remove="handleRemoveFile"
						  :file-list="formFile.${po.fieldName}">
						  <el-button size="small" type="primary">点击上传</el-button>
						</el-upload>
					</el-form-item>
				<#else>
					<el-form-item label="${po.content}" prop="${po.fieldName}">
						<el-input v-model="addForm.${po.fieldName}" auto-complete="off" placeholder="请输入${po.content}"></el-input>
					</el-form-item>
				</#if>
				</#list>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button @click.native="editFormVisible = false">取消</el-button>
				<el-button type="primary" @click.native="editSubmit" :loading="editLoading">提交</el-button>
			</div>
		</el-dialog>
		
		<!--新增界面-->
		<el-dialog title="新增" fullscreen :visible.sync="addFormVisible" :close-on-click-modal="false">
			<el-form :model="addForm" label-width="80px" :rules="addFormRules" ref="addForm" size="mini">
				<#list pageColumns as po>
				<#if po.showType=='text'>
					<el-form-item label="${po.content}" prop="${po.fieldName}">
						<el-input v-model="addForm.${po.fieldName}" auto-complete="off" placeholder="请输入${po.content}"></el-input>
					</el-form-item>
				<#elseif po.showType=='textarea'>
					<el-form-item label="${po.content}">
						<el-input type="textarea" v-model="addForm.${po.fieldName}"></el-input>
					</el-form-item>
				<#elseif po.showType=='password'>
					<el-form-item label="${po.content}">
						<el-input type="password" v-model="addForm.${po.fieldName}"></el-input>
					</el-form-item>
				<#elseif po.showType=='date'>
					<el-form-item label="${po.content}">
						<el-date-picker type="date" placeholder="选择${po.content}" v-model="addForm.${po.fieldName}"></el-date-picker>
					</el-form-item>
				<#elseif po.showType=='datetime'>
					<el-form-item label="${po.content}">
						 <el-date-picker type="datetime" placeholder="选择${po.content}" v-model="addForm.${po.fieldName}"></el-date-picker>
					</el-form-item>
				<#elseif po.showType=='checkbox'>
					<el-form-item label="${po.content}">
					    <el-select v-model="addForm.${po.fieldName}" multiple placeholder="请选择${po.content}">
					      <el-option :label="option.typename" :value="option.typecode" v-for="option in ${po.dictField}Options"></el-option>
					    </el-select>
					</el-form-item>
				<#elseif po.showType=='select' || po.showType=='list' || po.showType=='radio'>
					<el-form-item label="${po.content}">
						<el-select v-model="addForm.${po.fieldName}" placeholder="请选择${po.content}">
					      <el-option :label="option.typename" :value="option.typecode" v-for="option in ${po.dictField}Options"></el-option>
					    </el-select>
					</el-form-item>
				<#elseif po.showType=='file' || po.showType == 'image'>
					<el-form-item label="${po.content}" prop="${po.fieldName}">
						<el-upload
						  :action="url.upload"
						  :data="{isup:'1'}"
						  :on-success="handle${po.fieldName?cap_first}UploadFile"
						  :on-remove="handleRemoveFile"
						  :file-list="formFile.${po.fieldName}">
						  <el-button size="small" type="primary">点击上传</el-button>
						</el-upload>
					</el-form-item>
				<#else>
					<el-form-item label="${po.content}" prop="${po.fieldName}">
						<el-input v-model="addForm.${po.fieldName}" auto-complete="off" placeholder="请输入${po.content}"></el-input>
					</el-form-item>
				</#if>
				</#list>
			</el-form>
			<div slot="footer" class="dialog-footer">
				<el-button @click.native="addFormVisible = false">取消</el-button>
				<el-button type="primary" @click.native="addSubmit" :loading="addLoading">提交</el-button>
			</div>
		</el-dialog>
	</div>
</body>
<script>
	var vue = new Vue({			
		el:"#${entityName?uncap_first}List",
		data() {
			return {
				filters: {
					<#list columns as po>
				 	<#if po.isQuery =='Y'>
				 	<#if po.showType=='checkbox'>
					${po.fieldName}:[],
					<#elseif po.showType=='date' || po.showType=='datetime'>
					<#if po.queryMode=='group'>
					${po.fieldName}_begin:'',
					${po.fieldName}_end:'',
					<#else>
					${po.fieldName}:'',
					</#if>
					<#else>
					${po.fieldName}:'',
					</#if>
				 	</#if>
					</#list>
				},
				url:{
					list:'${entityName?uncap_first}Controller.do?datagrid',
					del:'${entityName?uncap_first}Controller.do?doDel',
					batchDel:'${entityName?uncap_first}Controller.do?doBatchDel',
					queryDict:'systemController.do?typeListJson',
					save:'${entityName?uncap_first}Controller.do?doAdd',
					edit:'${entityName?uncap_first}Controller.do?doUpdate',
					upload:'systemController/filedeal.do',
					downFile:'systemController/showOrDownByurl.do'
				},
				${entityName?uncap_first}s: [],
				total: 0,
				page: 1,
				pageSize:10,
				sort:{
					sort:'id',
					order:'desc'
				},
				listLoading: false,
				sels: [],//列表选中列
				
				editFormVisible: false,//编辑界面是否显示
				editLoading: false,

				addFormVisible: false,//新增界面是否显示
				addLoading: false,
				addFormRules: {
				<#list pageColumns as po>
				<#if po.isNull!= 'Y'>
					${po.fieldName}:[
						{required: true, message: '请输入${po.content}', trigger: 'blur'}
					],
				</#if>
				</#list>
				},
				//新增界面数据
				addForm: {},
				
				formFile: {
				<#list pageColumns as po>
				<#if po.showType=='file' || po.showType == 'image'>
					${po.fieldName}:[],
				</#if>
				</#list>
				},
				
				//数据字典 
				<#assign optionCodes="">
				<#list columns as mpo>
	    	 	<#if mpo.showType=='select' || mpo.showType=='list'  || mpo.showType=='checkbox' || mpo.showType=='radio'>
	    	 	<#if optionCodes?index_of(mpo.dictField) lt 0>
		   		<#assign optionCodes=optionCodes+","+mpo.dictField >
		   		${mpo.dictField}Options:[],
		   		</#if>
	    	 	</#if>
	    	 	</#list>
			}
		},
		methods: {
			<#list pageColumns as po>
			<#if po.showType=='file' || po.showType == 'image'>
			handle${po.fieldName?cap_first}UploadFile: function(response, file, fileList){
				file.url=response.obj;
				if(fileList.length>1){
					this.handleRemoveFile(fileList.splice(0,1)[0],fileList);
				}
				this.addForm.${po.fieldName}=response.obj;
			},
			</#if>
			</#list>
			handleRemoveFile: function(file, fileList){
				this.$http.get(this.url.upload,{
					params:{
						isdel:'1',
						path:file.url
					}
				}).then((res) => {
				});
			},
			handleSortChange(sort){
				this.sort={
					sort:sort.prop,
					order:sort.order=='ascending'?'asc':'desc'
				};
				this.get${entityName?cap_first}s();
			},
			handleDownFile(type,filePath){
				var downUrl=this.url.downFile+"?down="+type+"&dbPath="+filePath;
				window.open(downUrl);
			},
			formatDate: function(row,column,cellValue, index){
				return !!cellValue?utilFormatDate(new Date(cellValue), 'yyyy-MM-dd'):'';
			},
			formatDateTime: function(row,column,cellValue, index){
				return !!cellValue?utilFormatDate(new Date(cellValue), 'yyyy-MM-dd hh:mm:ss'):'';
			},
			<#assign optionCodes="">
			<#list columns as mpo>
			<#if mpo.isShowList?if_exists?html !='N'>
    	 	<#if mpo.showType=='select' || mpo.showType=='list'  || mpo.showType=='checkbox' || mpo.showType=='radio'>
    	 	<#if optionCodes?index_of(mpo.dictField) lt 0>
	   		<#assign optionCodes=optionCodes+","+mpo.dictField >
			format${mpo.dictField?cap_first}Dict: function(row,column,cellValue, index){
				var names="";
				var values=cellValue;
				if(!Array.isArray(cellValue))values=cellValue.split(',');
				for (var i = 0; i < values.length; i++) {
					var value = values[i];
					if(i>0)names+=",";
					for(var j in this.${mpo.dictField}Options){
						var option=this.${mpo.dictField}Options[j];
						if(value==option.typecode){
							names+=option.typename;
						}
					}
				}
				return names;
			},
    	 	</#if>
    	 	</#if>
    	 	</#if>
    	 	</#list>
			handleCurrentChange(val) {
				this.page = val;
				this.get${entityName?cap_first}s();
			},
			handleSizeChange(val) {
				this.pageSize = val;
				this.page = 1;
				this.get${entityName?cap_first}s();
			},
			resetForm(formName) {
		        this.$refs[formName].resetFields();
		        this.get${entityName?cap_first}s();
		    },
			//获取用户列表
			get${entityName?cap_first}s() {
				var fields=[];
				fields.push('id');
				<#list columns as po>
				fields.push('${po.fieldName}');
				</#list>
				let para = {
					params: {
						page: this.page,
						rows: this.pageSize,
						//排序
						sort:this.sort.sort,
						order:this.sort.order,
						<#list columns as po>
					 	<#if po.isQuery =='Y'>
					 	<#if po.showType=='date'>
					 	<#if po.queryMode=='group'>
					 	${po.fieldName}_begin: !this.filters.${po.fieldName}_begin ? '' : utilFormatDate(new Date(this.filters.${po.fieldName}_begin ), 'yyyy-MM-dd'),
						${po.fieldName}_end: !this.filters.${po.fieldName}_end ? '' : utilFormatDate(new Date(this.filters.${po.fieldName}_end ), 'yyyy-MM-dd'),
						<#else>
						${po.fieldName}: !this.filters.${po.fieldName} ? '' : utilFormatDate(new Date(this.filters.${po.fieldName} ), 'yyyy-MM-dd'),
						</#if>
						<#elseif po.showType=='datetime'>
						<#if po.queryMode=='group'>
					 	${po.fieldName}_begin: !this.filters.${po.fieldName}_begin ? '' : utilFormatDate(new Date(this.filters.${po.fieldName}_begin ), 'yyyy-MM-dd hh:mm:ss'),
					 	${po.fieldName}_end: !this.filters.${po.fieldName}_end ? '' : utilFormatDate(new Date(this.filters.${po.fieldName}_end ), 'yyyy-MM-dd hh:mm:ss'),
						<#else>
					 	${po.fieldName}: !this.filters.${po.fieldName} ? '' : utilFormatDate(new Date(this.filters.${po.fieldName} ), 'yyyy-MM-dd hh:mm:ss'),
						</#if>
						<#elseif po.showType=='checkbox'>
					 	${po.fieldName}:this.filters.${po.fieldName}.join(','),
						<#else>
					 	${po.fieldName}:this.filters.${po.fieldName},
						</#if>
					 	</#if>
						</#list>
						field:fields.join(',')
					}
				};
				this.listLoading = true;
				this.${'$'}http.get(this.url.list,para).then((res) => {
					this.total = res.data.total;
					var datas=res.data.rows;
					for (var i = 0; i < datas.length; i++) {
						var data = datas[i];
						<#list columns as po>
						<#if po.showType=='checkbox'>
						data.${po.fieldName}=data.${po.fieldName}.split(',');
						</#if>
						</#list>
					}
					this.${entityName?uncap_first}s = datas;
					this.listLoading = false;
				});
			},
			//删除
			handleDel: function (index, row) {
				this.${'$'}confirm('确认删除该记录吗?', '提示', {
					type: 'warning'
				}).then(() => {
					this.listLoading = true;
					let para = { id: row.id };
					this.${'$'}http.post(this.url.del,para,{emulateJSON: true}).then((res) => {
						this.listLoading = false;
						this.${'$'}message({
							message: '删除成功',
							type: 'success',
							duration:1500
						});
						this.get${entityName?cap_first}s();
					});
				}).catch(() => {

				});
			},
			//显示编辑界面
			handleEdit: function (index, row) {
				this.editFormVisible = true;
				this.addForm = Object.assign({}, row);
				this.formFile={
				<#list pageColumns as po>
				<#if po.showType=='file' || po.showType == 'image'>
					${po.fieldName}:[{
						name:this.addForm.${po.fieldName}.substring(this.addForm.${po.fieldName}.lastIndexOf('\\')+1),
						url:this.addForm.${po.fieldName}
					}],
				</#if>
				</#list>
				};
			},
			//显示新增界面
			handleAdd: function () {
				this.addFormVisible = true;
				this.addForm = {
					<#list pageColumns as po>
					<#if po.showType=='checkbox'>
					${po.fieldName}:[],
					<#else>
					${po.fieldName}:'',
					</#if>
					</#list>
				};
				this.formFile={
				<#list pageColumns as po>
				<#if po.showType=='file' || po.showType == 'image'>
					${po.fieldName}:[],
				</#if>
				</#list>
				};
			},
			//编辑
			editSubmit: function () {
				this.${'$'}refs.addForm.validate((valid) => {
					if (valid) {
						this.${'$'}confirm('确认提交吗？', '提示', {}).then(() => {
							this.editLoading = true;
							let para = Object.assign({}, this.addForm);
							<#list pageColumns as po>
							<#if po.showType=='date'>
							para.${po.fieldName} = !para.${po.fieldName} ? '' : utilFormatDate(new Date(para.${po.fieldName}), 'yyyy-MM-dd');
							<#elseif po.showType=='datetime'>
							para.${po.fieldName} = !para.${po.fieldName} ? '' : utilFormatDate(new Date(para.${po.fieldName}), 'yyyy-MM-dd hh:mm:ss');
							<#elseif po.showType=='checkbox'>
							para.${po.fieldName} = para.${po.fieldName}.join(',');
							</#if>
							</#list>
							this.${'$'}http.post(this.url.edit,para,{emulateJSON: true}).then((res) => {
								this.editLoading = false;
								this.${'$'}message({
									message: '提交成功',
									type: 'success',
									duration:1500
								});
								this.${'$'}refs['addForm'].resetFields();
								this.editFormVisible = false;
								this.get${entityName?cap_first}s();
							});
						});
					}
				});
			},
			//新增
			addSubmit: function () {
				this.${'$'}refs.addForm.validate((valid) => {
					if (valid) {
						this.${'$'}confirm('确认提交吗？', '提示', {}).then(() => {
							this.addLoading = true;
							let para = Object.assign({}, this.addForm);
							
							<#list pageColumns as po>
							<#if po.showType=='date'>
							para.${po.fieldName} = !para.${po.fieldName} ? '' : utilFormatDate(new Date(para.${po.fieldName}), 'yyyy-MM-dd');
							<#elseif po.showType=='datetime'>
							para.${po.fieldName} = !para.${po.fieldName} ? '' : utilFormatDate(new Date(para.${po.fieldName}), 'yyyy-MM-dd hh:mm:ss');
							<#elseif po.showType=='checkbox'>
							para.${po.fieldName} = para.${po.fieldName}.join(',');
							</#if>
							</#list>
							
							this.${'$'}http.post(this.url.save,para,{emulateJSON: true}).then((res) => {
								this.addLoading = false;
								this.${'$'}message({
									message: '提交成功',
									type: 'success',
									duration:1500
								});
								this.${'$'}refs['addForm'].resetFields();
								this.addFormVisible = false;
								this.get${entityName?cap_first}s();
							});
						});
					}
				});
			},
			selsChange: function (sels) {
				this.sels = sels;
			},
			//批量删除
			batchRemove: function () {
				var ids = this.sels.map(item => item.id).toString();
				this.${'$'}confirm('确认删除选中记录吗？', '提示', {
					type: 'warning'
				}).then(() => {
					this.listLoading = true;
					let para = { ids: ids };
					this.${'$'}http.post(this.url.batchDel,para,{emulateJSON: true}).then((res) => {
						this.listLoading = false;
						this.${'$'}message({
							message: '删除成功',
							type: 'success',
							duration:1500
						});
						this.get${entityName?cap_first}s();
					});
				}).catch(() => {
				});
			},
			//初始化数据字典
			initDictsData:function(){
	        	var _this = this;
	        	<#assign optionCodes="">
	    		<#list columns as mpo>
	    	 	<#if mpo.showType=='select' || mpo.showType=='list'  || mpo.showType=='checkbox' || mpo.showType=='radio'>
	    	 	<#if optionCodes?index_of(mpo.dictField) lt 0>
		   		<#assign optionCodes=optionCodes+","+mpo.dictField >
		   		_this.initDictByCode('${mpo.dictField}',_this,'${mpo.dictField}Options');
		   		</#if>
	    	 	</#if>
	    	 	</#list>
	        },
	        initDictByCode:function(code,_this,dictOptionsName){
	        	if(!code || !_this[dictOptionsName] || _this[dictOptionsName].length>0)
	        		return;
	        	this.${'$'}http.get(this.url.queryDict,{params: {typeGroupName:code}}).then((res) => {
	        		var data=res.data;
					if(data.success){
					  _this[dictOptionsName] = data.obj;
					  _this[dictOptionsName].splice(0, 1);//去掉请选择
					}
				});
	        }
		},
		mounted() {
			this.initDictsData();
			this.get${entityName?cap_first}s();
		}
	});
	
	function utilFormatDate(date, pattern) {
        pattern = pattern || "yyyy-MM-dd";
        return pattern.replace(/([yMdhsm])(\1*)/g, function (${'$'}0) {
            switch (${'$'}0.charAt(0)) {
                case 'y': return padding(date.getFullYear(), ${'$'}0.length);
                case 'M': return padding(date.getMonth() + 1, ${'$'}0.length);
                case 'd': return padding(date.getDate(), ${'$'}0.length);
                case 'w': return date.getDay() + 1;
                case 'h': return padding(date.getHours(), ${'$'}0.length);
                case 'm': return padding(date.getMinutes(), ${'$'}0.length);
                case 's': return padding(date.getSeconds(), ${'$'}0.length);
            }
        });
    };
	function padding(s, len) {
	    var len = len - (s + '').length;
	    for (var i = 0; i < len; i++) { s = '0' + s; }
	    return s;
	};
</script>
</html>