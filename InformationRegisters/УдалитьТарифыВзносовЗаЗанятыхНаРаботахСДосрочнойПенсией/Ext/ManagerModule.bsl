﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение сведений.
Процедура НачальноеЗаполнение() Экспорт
	
	ЗаполнитьТарифыДополнительныхВзносовЗаЗанятыхНаРаботахСДосрочнойПенсией();
	
КонецПроцедуры

Процедура ЗаполнитьТарифыДополнительныхВзносовЗаЗанятыхНаРаботахСДосрочнойПенсией()

	НаборЗаписей = РегистрыСведений.ТарифыВзносовЗаЗанятыхНаРаботахСДосрочнойПенсией.СоздатьНаборЗаписей();	
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
	
	Запись = НаборЗаписей.Добавить();
	Запись.Период = '20130101';
	Запись.ЗаЗанятыхНаПодземныхИВредныхРаботах = 4;
	Запись.ЗаЗанятыхНаТяжелыхИПрочихРаботах = 2;
	Запись = НаборЗаписей.Добавить();
	Запись.Период = '20140101';
	Запись.ЗаЗанятыхНаПодземныхИВредныхРаботах = 6;
	Запись.ЗаЗанятыхНаТяжелыхИПрочихРаботах = 4;
	Запись = НаборЗаписей.Добавить();
	Запись.Период = '20150101';
	Запись.ЗаЗанятыхНаПодземныхИВредныхРаботах = 9;
	Запись.ЗаЗанятыхНаТяжелыхИПрочихРаботах = 6;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли