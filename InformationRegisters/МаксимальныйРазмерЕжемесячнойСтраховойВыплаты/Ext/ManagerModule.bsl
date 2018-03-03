﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

//////////////////////////////////////////////////////////////////
/// Первоначальное заполнение и обновление информационной базы.

Процедура НачальноеЗаполнение() Экспорт
	
	Если ОбменДаннымиПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		Возврат;
	КонецЕсли;

	ЗаполнитьМаксимальныеРазмерыЕжемесячнойСтраховойВыплаты();
	
КонецПроцедуры

// Процедура заполняет максимальные размеры ежемесячной страховой выплаты по данным.
// Федерального закона N219-ФЗ от 03.12.2012.
Процедура ЗаполнитьМаксимальныеРазмерыЕжемесячнойСтраховойВыплаты() Экспорт
	
	НаборЗаписей = РегистрыСведений.МаксимальныйРазмерЕжемесячнойСтраховойВыплаты.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20130101';
	НоваяСтрока.Размер = 58970;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20140101';
	НоваяСтрока.Размер = 61920;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20150101';
	НоваяСтрока.Размер = 65330;
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = '20160201';
	НоваяСтрока.Размер = 69510;
	
    НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Период = '20170101';
	НоваяЗапись.Размер = 72290.4;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли