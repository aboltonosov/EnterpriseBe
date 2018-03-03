﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// 4D:ERP для Беларуси, Юлия, 31.10.2017 9:35:21 
// Док-т "Больничный". Не записывается рассчитанный средний заработок., № 16450
// РС "Предельные величины страховых взносов", № 16464
// {
// Процедура выполняет первоначальное заполнение сведений.
Процедура НачальноеЗаполнение() Экспорт
	
	ЗаполнитьПредельнуюВеличинуБазыСтраховыхВзносов();

КонецПроцедуры

Процедура ЗаполнитьПредельнуюВеличинуБазыСтраховыхВзносов() Экспорт
	
	НаборЗаписей = РегистрыСведений.ПредельнаяВеличинаБазыСтраховыхВзносов.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20170101';
	НоваяСтрока.РазмерФСЗН = 720.7*5;		
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20170201';
	НоваяСтрока.РазмерФСЗН = 716.5*5;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20170301';
	НоваяСтрока.РазмерФСЗН = 770.6*5;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20170401';
	НоваяСтрока.РазмерФСЗН = 776.6*5;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20170501';
	НоваяСтрока.РазмерФСЗН = 795.2*5;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20170601';
	НоваяСтрока.РазмерФСЗН = 819.3*5;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20170701';
	НоваяСтрока.РазмерФСЗН = 827.5*5;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20170801';
	НоваяСтрока.РазмерФСЗН = 844.4*5;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20170901';
	НоваяСтрока.РазмерФСЗН = 831.3*5;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры
// }
// 4D

#КонецОбласти

#КонецЕсли