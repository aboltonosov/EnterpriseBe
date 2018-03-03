﻿// 4D:ERP для Беларуси
// {
// Форма изменена
// }
// 4D

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Документ") И
		ЗначениеЗаполнено(Параметры.Документ) Тогда
		
		ЭлементОтбораДанных = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Документ");
		ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораДанных.ПравоеЗначение = Параметры.Документ;
		ЭлементОтбораДанных.Использование = Истина;
				
	КонецЕсли;	
	
КонецПроцедуры
