﻿//////////////////////////////////////////////////////////////////////////////////////////////
// Проверка документов: методы, работающие на  стороне сервера, вызываемые со стороны клиента.
//  
//////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет команду "Проверки" документа. В случае если прав на изменение статуса проверки нет - ничего не делает,
// в противном случае изменяет значение статуса проверки документа.
// (см. метод регистра сведений "РегистрыСведений.СтатусыПроверкиДокументов.УстановитьСтатусПроверкиДокументов").
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Документ, для которого требуется изменить статус проверки
//	(см. измерение "Документ" регистра сведений "СтатусыПроверкиДокументов");
//	ДанныеОбОшибке - Соответствие - соответствие данных (если не задано - данные об ошибках не фиксируются):
//			* ДанныеОшибок.Ключ - ДокументСсылка - ссылка на документ, статус проверки которого изменяется;
//			* ДанныеОшибок.Значение - Строка - выводимая пользователю информация об ошибке;
//
//	ВозвращаемоеЗначение:
//		Булево - Истина, если есть право на изменение документа, Ложь в противном случае.
//
Процедура ВыполнитьКомандуИзмененияСтатусаПроверкиДокумента(ДокументСсылка, ДанныеОбОшибке = Неопределено) Экспорт
	
	РегистрыСведений.СтатусыПроверкиДокументов.УстановитьСтатусПроверкиДокументов(ДокументСсылка, ДанныеОбОшибке);
	
КонецПроцедуры

#КонецОбласти