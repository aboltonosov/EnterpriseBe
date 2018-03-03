﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

//////////////////////////////////////////////////////////////////
/// Первоначальное заполнение и обновление информационной базы

// Процедура заполняет сведения о действующих размерах пособий
//
Процедура ЗаполнитьГосударственныеПособия() Экспорт
	
	НаборЗаписей = РегистрыСведений.РазмерыГосударственныхПособий.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
	
	КлассификаторXML = РегистрыСведений.РазмерыГосударственныхПособий.ПолучитьМакет("ГосударственныеПособия").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	ТекущаяДата = Неопределено;
	ПредыдущаяЗапись = Неопределено;
	Для Каждого СтрокаКлассификатора ИЗ КлассификаторТаблица Цикл
		ДатаЗаписи = Дата(СтрокаКлассификатора.Date);
		Если ТекущаяДата <> ДатаЗаписи Тогда
			СтрокаНабора = НаборЗаписей.Добавить();
			Если ЗначениеЗаполнено(ТекущаяДата) Тогда
				ЗаполнитьЗначенияСвойств(СтрокаНабора, ПредыдущаяЗапись);
			КонецЕсли;
			СтрокаНабора.Период = ДатаЗаписи;
			ТекущаяДата = ДатаЗаписи;
			ПредыдущаяЗапись = СтрокаНабора; 
		КонецЕсли;
		СтрокаНабора[СтрокаКлассификатора.Benefit]	= Число(СтрокаКлассификатора.Rate);
	КонецЦикла;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Период = '20130101';
	НоваяЗапись.ПриПостановкеНаУчетВРанниеСрокиБеременности = 490.79;
	НоваяЗапись.ПриРожденииРебенка = 13087.61;
	НоваяЗапись.МинимумПособияПоУходуЗаПервымРебенкомДоПолутораЛет = 2453.93;
	НоваяЗапись.МинимумПособияПоУходуЗаПоследующимРебенкомДоПолутораЛет = 4907.85;
	НоваяЗапись.МаксимумПособияПоУходуЗаРебенкомДоПолутораЛет = 9815.71;
	НоваяЗапись.ВСвязиСоСмертью = 4763.96;
	НоваяЗапись.ПоУходуЗаРебенкомДоТрехЛет = 50;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Период = '20140101';
	НоваяЗапись.ПриПостановкеНаУчетВРанниеСрокиБеременности = 515.33;
	НоваяЗапись.ПриРожденииРебенка = 13741.99;
	НоваяЗапись.МинимумПособияПоУходуЗаПервымРебенкомДоПолутораЛет = 2576.63;
	НоваяЗапись.МинимумПособияПоУходуЗаПоследующимРебенкомДоПолутораЛет = 5153.24;
	НоваяЗапись.МаксимумПособияПоУходуЗаРебенкомДоПолутораЛет = 10306.50;
	НоваяЗапись.ВСвязиСоСмертью = 5002.16;
	НоваяЗапись.ПоУходуЗаРебенкомДоТрехЛет = 50;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Период = '20150101';
	НоваяЗапись.ПриПостановкеНаУчетВРанниеСрокиБеременности = 543.67;
	НоваяЗапись.ПриРожденииРебенка = 14497.80;
	НоваяЗапись.МинимумПособияПоУходуЗаПервымРебенкомДоПолутораЛет = 2718.34;
	НоваяЗапись.МинимумПособияПоУходуЗаПоследующимРебенкомДоПолутораЛет = 5436.67;
	НоваяЗапись.МаксимумПособияПоУходуЗаРебенкомДоПолутораЛет = 10873.36;
	НоваяЗапись.ВСвязиСоСмертью = 5277.28;
	НоваяЗапись.ПоУходуЗаРебенкомДоТрехЛет = 50;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Период = '20160201';
	НоваяЗапись.ПриПостановкеНаУчетВРанниеСрокиБеременности = 581.73;
	НоваяЗапись.ПриРожденииРебенка = 15512.65;
	НоваяЗапись.МинимумПособияПоУходуЗаПервымРебенкомДоПолутораЛет = 2908.62;
	НоваяЗапись.МинимумПособияПоУходуЗаПоследующимРебенкомДоПолутораЛет = 5817.24;
	НоваяЗапись.МаксимумПособияПоУходуЗаРебенкомДоПолутораЛет = 11634.50;
	НоваяЗапись.ВСвязиСоСмертью = 5277.28;
	НоваяЗапись.ПоУходуЗаРебенкомДоТрехЛет = 50;
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Период = '20170201';
	НоваяЗапись.ПриПостановкеНаУчетВРанниеСрокиБеременности = 613.14;
	НоваяЗапись.ПриРожденииРебенка = 16350.33;
	НоваяЗапись.МинимумПособияПоУходуЗаПервымРебенкомДоПолутораЛет = 3065.69;
	НоваяЗапись.МинимумПособияПоУходуЗаПоследующимРебенкомДоПолутораЛет = 6131.37;
	НоваяЗапись.МаксимумПособияПоУходуЗаРебенкомДоПолутораЛет = 12262.76;
	НоваяЗапись.ВСвязиСоСмертью = 5562.25;
	НоваяЗапись.ПоУходуЗаРебенкомДоТрехЛет = 50;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецЕсли