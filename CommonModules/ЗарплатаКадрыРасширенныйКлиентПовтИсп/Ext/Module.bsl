﻿
#Область СлужебныйПрограммныйИнтерфейс

// Получает информацию о виде расчета.
Функция ПолучитьИнформациюОВидеРасчета(ВидРасчета) Экспорт
	Возврат ЗарплатаКадрыРасширенныйВызовСервера.ПолучитьИнформациюОВидеРасчета(ВидРасчета);
КонецФункции

Функция СведенияОПоказателеРасчетаЗарплаты(Показатель) Экспорт
	Возврат ЗарплатаКадрыРасширенныйВызовСервера.СведенияОПоказателеРасчетаЗарплаты(Показатель);
КонецФункции

Функция МаксимальноеКоличествоОтображаемыхПоказателей(ИмяПВР = "Начисления") Экспорт
	Возврат ЗарплатаКадрыРасширенныйВызовСервера.МаксимальноеКоличествоОтображаемыхПоказателей(ИмяПВР);
КонецФункции

Функция ИменаПредопределенныхПоказателей() Экспорт 
	
	Возврат ЗарплатаКадрыРасширенныйВызовСервера.ИменаПредопределенныхПоказателей();
	
КонецФункции

Функция ОписаниеШкалыПорядкаНачисленияПроцентовСевернойНадбавки(ПорядокНачисления) Экспорт
	
	Возврат ЗарплатаКадрыРасширенныйВызовСервера.ОписаниеШкалыПорядкаНачисленияПроцентовСевернойНадбавки(ПорядокНачисления);
	
КонецФункции

Функция ФизическоеЛицоСотрудника(Сотрудник) Экспорт
	
	Возврат ЗарплатаКадрыРасширенныйВызовСервера.ФизическоеЛицоСотрудника(Сотрудник);
	
КонецФункции

Функция ДанныеТарифныхСеток(ТарифнаяСетка, РазрядКатегория, ТарифнаяСеткаНадбавки, РазрядКатегорияНадбавки, ДатаСведений, СчитатьПоказателиПоДолжности, ПКУ) Экспорт
	
	Возврат ЗарплатаКадрыРасширенныйВызовСервера.ДанныеТарифныхСеток(ТарифнаяСетка, РазрядКатегория, ТарифнаяСеткаНадбавки, РазрядКатегорияНадбавки, ДатаСведений, СчитатьПоказателиПоДолжности, ПКУ);
	
КонецФункции

Функция ОписаниеСпособаОкругления(Знач СпособОкругления) Экспорт
	
	Возврат ЗарплатаКадрыРасширенныйВызовСервера.ОписаниеСпособаОкругления(СпособОкругления);
	
КонецФункции

Функция СтруктураПоМетаданным(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Возврат ЗарплатаКадрыРасширенныйВызовСервера.СтруктураПоМетаданным(ПолноеИмяОбъектаМетаданных);
	
КонецФункции

Функция ЭтоСеверныйСтаж(ВидСтажа) Экспорт
	
	Возврат ЗарплатаКадрыРасширенныйВызовСервера.ЭтоСеверныйСтаж(ВидСтажа);
	
КонецФункции

#КонецОбласти
