﻿#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОперациюЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	ЭтотОбъект.Доступность = Истина;
	
	Если РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru = 'Операция выполнена успешно.'");
	Иначе
		ТекстСообщения = РезультатВыполнения.ОписаниеОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперациюПоПлатежнойКарте(ТипТранзакции)
	
	ОчиститьСообщения();
	ПараметрыОперации = Новый Структура();
	ПараметрыОперации.Вставить("ТипТранзакции"               , ТипТранзакции);
	ПараметрыОперации.Вставить("УказатьДополнительныеДанные" , Истина);
	ПараметрыОперации.Вставить("ЗапретРедактированияСуммы"   , Ложь);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОперациюПоПлатежнойКартеЗавершение", ЭтотОбъект, ПараметрыОперации);
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.Форма.ФормаАвторизацииЭТ", ПараметрыОперации,,,  ,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперациюПоПлатежнойКартеЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		Если НЕ Параметры.Свойство("ТипТранзакции") Тогда
			ТекстСообщения = НСтр("ru = 'Не указан тип транзакции.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
	
		ЭтотОбъект.Доступность = Ложь;
		ПараметрыОперации = МенеджерОборудованияКлиент.ПараметрыВыполненияЭквайринговойОперации();
		ПараметрыОперации.ТипТранзакции  = Параметры.ТипТранзакции;
		ПараметрыОперации.СуммаОперации  = Результат.Сумма;
		ПараметрыОперации.НомерЧека      = ?(Результат.Свойство("НомерЧека"), Результат.НомерЧека, "");
		ПараметрыОперации.СсылочныйНомер = Результат.СсылочныйНомер;
		
		Оповещение = Новый ОписаниеОповещения("ВыполнитьОперациюЗавершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.НачатьВыполнениеОперацииНаЭквайринговомТерминале(Оповещение, УникальныйИдентификатор, Неопределено, Неопределено, ПараметрыОперации);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьПлатежнойКартой(Команда)
	
	ВыполнитьОперациюПоПлатежнойКарте("AuthorizeSales");
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьПлатежПоКарте(Команда)
	
	ВыполнитьОперациюПоПлатежнойКарте("AuthorizeRefund");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПлатежПоКарте(Команда)
	
	ВыполнитьОперациюПоПлатежнойКарте("AuthorizeVoid");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПреавторизацию(Команда)
	
	ВыполнитьОперациюПоПлатежнойКарте("AuthorizePreSales");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПреавторизацию(Команда)
	
	ВыполнитьОперациюПоПлатежнойКарте("AuthorizeCompletion");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПреавторизацию(Команда)
	
	ВыполнитьОперациюПоПлатежнойКарте("AuthorizeVoidPreSales");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСверкуИтогов(Команда)
	
	ОчиститьСообщения();
	ЭтотОбъект.Доступность = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьОперациюЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьВыполнениеСверкиИтоговНаЭквайринговомТерминале(ОписаниеОповещения, УникальныйИдентификатор)
	
КонецПроцедуры

&НаКлиенте
Процедура НапечататьПоследнийСлипЧек(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПустаяСтрока(глПодключаемоеОборудование.ПоследнийСлипЧек) Тогда
		ЭтотОбъект.Доступность = Ложь;
		Оповещение = Новый ОписаниеОповещения("ВыполнитьОперациюЗавершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.НачатьПечатьТекста(Оповещение, УникальныйИдентификатор, глПодключаемоеОборудование.ПоследнийСлипЧек);
	Иначе
		ТекстСообщения = НСтр("ru = 'Отсутствует последний слип чек.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти