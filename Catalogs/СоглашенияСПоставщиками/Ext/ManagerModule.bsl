﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет таблицу реквизитов, зависимых от хозяйственной операции
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - хозяйственная операция соглашения
//	МассивВсехРеквизитов - Массив - реквизиты, которые не зависят от хозяйственной операции
//	МассивРеквизитовОперации - Массив - реквизиты, которые зависят от хозяйственной операции
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("СпособРасчетаВознаграждения");
	МассивВсехРеквизитов.Добавить("ПроцентВознаграждения");
	МассивВсехРеквизитов.Добавить("УдержатьВознаграждение");
	МассивВсехРеквизитов.Добавить("ПроцентРучнойСкидки");
	МассивВсехРеквизитов.Добавить("ПроцентРучнойНаценки");
	МассивВсехРеквизитов.Добавить("НалогообложениеНДС");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию Тогда
		МассивРеквизитовОперации.Добавить("НалогообложениеНДС");
		МассивРеквизитовОперации.Добавить("СпособРасчетаВознаграждения");
		МассивРеквизитовОперации.Добавить("ПроцентВознаграждения");
		МассивРеквизитовОперации.Добавить("УдержатьВознаграждение");
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОказаниеАгентскихУслуг Тогда
		МассивРеквизитовОперации.Добавить("НалогообложениеНДС");
		МассивРеквизитовОперации.Добавить("СпособРасчетаВознаграждения");
		МассивРеквизитовОперации.Добавить("ПроцентВознаграждения");
		МассивРеквизитовОперации.Добавить("УдержатьВознаграждение");
		МассивРеквизитовОперации.Добавить("ТипыУслуг");
		МассивРеквизитовОперации.Добавить("АгентскиеУслуги");
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту 
			ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС Тогда
		МассивРеквизитовОперации.Добавить("ПроцентРучнойСкидки");
		МассивРеквизитовОперации.Добавить("ПроцентРучнойНаценки");
	Иначе
		МассивРеквизитовОперации.Добавить("НалогообложениеНДС");
		МассивРеквизитовОперации.Добавить("ПроцентРучнойСкидки");
		МассивРеквизитовОперации.Добавить("ПроцентРучнойНаценки");
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает статус соглашений с поставщиками
//
// Параметры:
//	Соглашения - Массив - массив ссылок на соглашения с поставщиками
//	Статус     - ПеречислениеСсылка.СтатусыСоглашенийСПоставщиками - статус, который будет установлен у соглашений.
//
// Возвращаемое значение:
//	Число - количество обработанных строк
//
Функция УстановитьСтатус(Знач Соглашения, Знач Статус) Экспорт
	
	МассивСсылок = Новый Массив();
	КоличествоОбработанных = 0;
	
	Для Каждого Соглашение Из Соглашения Цикл
	
		Если ТипЗнч(Соглашение) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		МассивСсылок.Добавить(Соглашение);
		
	КонецЦикла;
	
	Если МассивСсылок = 0 Тогда
		Возврат КоличествоОбработанных;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СоглашениеСПоставщиком.Ссылка КАК Ссылка,
	|	СоглашениеСПоставщиком.ПометкаУдаления КАК ПометкаУдаления,
	|	ВЫБОР
	|		КОГДА СоглашениеСПоставщиком.Статус = &Статус
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СтатусСовпадает
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК СоглашениеСПоставщиком
	|ГДЕ
	|	СоглашениеСПоставщиком.Ссылка В(&МассивСсылок)");
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.УстановитьПараметр("Статус", Статус);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ПометкаУдаления Тогда
			
			ТекстОшибки = НСтр("ru='Соглашение %Соглашение% помечено на удаление. Невозможно изменить статус'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			Продолжить;
			
		КонецЕслИ;
		
		Если Выборка.СтатусСовпадает Тогда
			
			ТекстОшибки = НСтр("ru='Соглашению %Соглашение% уже присвоен статус ""%Статус%""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Статус%", Статус);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			Продолжить;
			
		КонецЕслИ;
		
		Попытка
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
		Исключение
			
			ТекстОшибки = НСтр("ru='Не удалось заблокировать %Соглашение%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			
		КонецПопытки;
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.Статус = Статус;
		
		Если Статус = Перечисления.СтатусыСоглашенийСКлиентами.НеСогласовано Тогда
			Если Объект.Согласован Тогда
				Объект.Согласован = Ложь;
			КонецЕсли;
		КонецЕсли;
			
		Если Не Объект.ПроверитьЗаполнение() Тогда
			Продолжить;
		КонецЕсли;
			
		Попытка
			
			Объект.Записать();
			КоличествоОбработанных = КоличествоОбработанных + 1;
			
		Исключение
			
			ТекстОшибки = НСтр("ru='Не удалось записать %Соглашение%. %ОписаниеОшибки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Соглашение%", Выборка.Ссылка);
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОписаниеОшибки%", КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Ссылка);
			
		КонецПопытки
		
	КонецЦикла;
	
	Возврат КоличествоОбработанных;

КонецФункции

// Ищет/создает документ регистрации для соглашения.
//
// Параметры:
//  Соглашение - СправочникСсылка.СоглашенияСПоставщиками - ссылка на соглашение, для которого необходимо создать документ
//
// Возвращаемое значение:
//  ДокументСсылка.СоглашениеСПоставщиком - ссылка на документ
//
Функция ПолучитьСоздатьДокументРегистрации(Соглашение) Экспорт
	
	Результат = ПолучитьДокументРегистрации(Соглашение);
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		СоглашениеСПоставщиком = Документы.СоглашениеСПоставщиком.СоздатьДокумент();
		СоглашениеСПоставщиком.Дата       = ТекущаяДата();
		СоглашениеСПоставщиком.Соглашение = Соглашение;
		СоглашениеСПоставщиком.Записать();
		
		Результат = СоглашениеСПоставщиком.Ссылка;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Ищет документ регистрации для соглашения.
//
// Параметры:
//  Соглашение - СправочникСсылка.СоглашенияСПоставщиками - ссылка на соглашение, для которого необходимо создать документ
//
// Возвращаемое значение:
//  ДокументСсылка.СоглашениеСПоставщиком - ссылка на документ
//
Функция ПолучитьДокументРегистрации(Соглашение) Экспорт
	
	Результат = Документы.СоглашениеСПоставщиком.ПустаяСсылка();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таблица.Ссылка КАК Документ
	|ИЗ
	|	Документ.СоглашениеСПоставщиком КАК Таблица
	|ГДЕ
	|	Таблица.Соглашение = &Соглашение");
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Документ;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает признак использования как агрегирующей сущности в товарах к поступлению
//
// Параметры:
//  ВариантПриемкиТоваров - ПеречислениеСсылка.ВариантыПриемкиТоваров - ссылка на вариант приемки
//
// Возвращаемое значение:
//  Булево - используется или нет соглашение при приемке.
//
Функция СоглашениеИспользуетсяПриПриемке(Знач ВариантПриемкиТоваров) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВариантПриемкиТоваров) Тогда
		ВариантПриемкиТоваров = Константы.ВариантПриемкиТоваров.Получить();
	КонецЕсли;
	
	Результат = Ложь;
	Если ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным
		Или ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.МожетПроисходитьБезЗаказовИНакладных 
		ИЛИ ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоНакладным Тогда 

		Результат = Истина;

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

// Создает соглашение по умолчанию.
//
// Параметры:
//  Параметры - Структура - структура заполнения
//
// Возвращаемое значение:
//  СправочникСсылка.СоглашениеСПоставщиком - ссылка на созданное соглашение
//
Функция СоздатьСоглашениеПоУмолчанию(Знач Параметры) Экспорт
	
	Соглашение = Справочники.СоглашенияСПоставщиками.СоздатьЭлемент();
	Соглашение.Заполнить(Неопределено);
	ЗаполнитьЗначенияСвойств(Соглашение, Параметры);
	Соглашение.Дата = ТекущаяДата();
	Соглашение.Статус = Перечисления.СтатусыСоглашенийСПоставщиками.Действует;
	
	Если НЕ ЗначениеЗаполнено(Соглашение.Наименование) Тогда
		Соглашение.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Условия закупок с %1'"), Соглашение.Партнер);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Соглашение.ВариантПриемкиТоваров) ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам") Тогда
		Соглашение.ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Соглашение.ПорядокОплаты) Тогда
		Соглашение.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВРублях;
	КонецЕсли;
	
	Соглашение.Записать();
	
	Возврат Соглашение.Ссылка
	
КонецФункции 

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Партнер       = Справочники.Партнеры.ПустаяСсылка();
	ДатаДокумента = ТекущаяДата();
	СтрокаПоиска  = "";
	
	Если Параметры.Отбор.Свойство("Партнер") Тогда
		Партнер = Параметры.Отбор.Партнер;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Партнер) Тогда
		Возврат;
	КонецЕсли;
		
	Если Параметры.Отбор.Свойство("Дата") Тогда
		ДатаДокумента = Параметры.Отбор.Дата;
	КонецЕсли;
	
	Параметры.Свойство("СтрокаПоиска",СтрокаПоиска);
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 51
		|	СправочникСоглашениеСПоставщиком.Ссылка       КАК Ссылка,
		|	СправочникСоглашениеСПоставщиком.Наименование КАК Наименование,
		|	СправочникСоглашениеСПоставщиком.Номер        КАК Номер,
		|	СправочникСоглашениеСПоставщиком.Дата         КАК Дата,
		|	ВЫБОР
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.ПометкаУдаления
		|		ТОГДА
		|			0
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
		|		ТОГДА
		|			0
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.НеСогласовано)
		|		ТОГДА
		|			1
		|	КОНЕЦ КАК ИндексКартинки,
		|
		|	ВЫБОР
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
		|			И ((СправочникСоглашениеСПоставщиком.ДатаНачалаДействия <> ДАТАВРЕМЯ(1,1,1) И
		|			СправочникСоглашениеСПоставщиком.ДатаНачалаДействия > &ДатаДокумента))
		|		ТОГДА
		|			ИСТИНА
		|		ИНАЧЕ
		|			ЛОЖЬ
		|	КОНЕЦ КАК СрокДействияНеНаступил,
		|
		|	ВЫБОР
		|		КОГДА
		|			СправочникСоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
		|			И ((СправочникСоглашениеСПоставщиком.ДатаОкончанияДействия <> ДАТАВРЕМЯ(1,1,1) И
		|			СправочникСоглашениеСПоставщиком.ДатаОкончанияДействия < &ДатаДокумента))
		|		ТОГДА
		|			ИСТИНА
		|		ИНАЧЕ
		|			ЛОЖЬ
		|	КОНЕЦ КАК СрокДействияИстек
		|
		|ИЗ
		|	Справочник.СоглашенияСПоставщиками КАК СправочникСоглашениеСПоставщиком
		|ГДЕ
		|	СправочникСоглашениеСПоставщиком.Партнер = &Партнер
		|	И СправочникСоглашениеСПоставщиком.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Закрыто)
		|	И (СправочникСоглашениеСПоставщиком.Наименование ПОДОБНО &СтрокаПоиска
		|	ИЛИ СправочникСоглашениеСПоставщиком.Номер ПОДОБНО &СтрокаПоиска)
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачалаДействия ВОЗР,
		|	ДатаОкончанияДействия ВОЗР
		|");
		
	Запрос.УстановитьПараметр("Партнер",       Партнер);
	Запрос.УстановитьПараметр("ДатаДокумента", НачалоДня(ДатаДокумента));
	Запрос.УстановитьПараметр("СтрокаПоиска",  СтрокаПоиска + "%");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ДанныеВыбора = Новый СписокЗначений();
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если ЗначениеЗаполнено(Выборка.Наименование) И
				ЗначениеЗаполнено(Выборка.Дата) И
				ЗначениеЗаполнено(Выборка.Номер) Тогда
				
				Представление = НСтр("ru='%Наименование% (%Номер% от %Дата%)'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				Представление = СтрЗаменить(Представление,"%Номер%",        Выборка.Номер);
				Представление = СтрЗаменить(Представление,"%Дата%",         Формат(Выборка.Дата, "ДЛФ=D"));
				
			ИначеЕсли ЗначениеЗаполнено(Выборка.Наименование) И
				ЗначениеЗаполнено(Выборка.Дата) Тогда
				
				Представление = НСтр("ru='%Наименование% (от %Дата%)'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				Представление = СтрЗаменить(Представление,"%Дата%",         Формат(Выборка.Дата, "ДЛФ=D"));
				
			ИначеЕсли ЗначениеЗаполнено(Выборка.Наименование) И
				ЗначениеЗаполнено(Выборка.Номер) Тогда
				
				Представление = НСтр("ru='%Наименование% (%Номер%)'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				Представление = СтрЗаменить(Представление,"%Номер%",        Выборка.Номер);
				
			Иначе
				
				Представление = НСтр("ru='%Наименование%'");
				Представление = СтрЗаменить(Представление,"%Наименование%", Выборка.Наименование);
				
			КонецЕсли;
			
			Структура = Новый Структура();
			Структура.Вставить("Значение", Выборка.Ссылка);
			
			Если Выборка.СрокДействияНеНаступил Тогда
				Структура.Вставить("Предупреждение", НСтр("ru='У соглашения не наступил срок действия.'"));
			ИначеЕсли Выборка.СрокДействияИстек Тогда
				Структура.Вставить("Предупреждение", НСтр("ru='У соглашения истек срок действия.'"));
			КонецЕсли;
			
			Если Выборка.ИндексКартинки = 0 Тогда
				Картинка = БиблиотекаКартинок.СоглашениеСПоставщиком;
			Иначе
				Картинка = БиблиотекаКартинок.СоглашениеСПоставщикомНеСогласовано;
			КонецЕсли;
				
			ДанныеВыбора.Добавить(
				Структура,
				Представление,
				,
				Картинка);
			
		КонецЦикла;
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область СозданиеНаОсновании

Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	НоваяКоманда = Справочники.ДоговорыКонтрагентов.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	
	Если НоваяКоманда <> Неопределено Тогда
		НоваяКоманда.ФункциональныеОпции = "ИспользоватьДоговорыСПоставщиками";
	КонецЕсли;
	
	ВводНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСоздатьНаОсновании);
	
	Документы.ЗаказПоставщику.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	
	Документы.ПоступлениеТоваровУслуг.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	
	Документы.РегистрацияЦенНоменклатурыПоставщика.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	
	Документы.СообщениеSMS.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	
КонецПроцедуры

#КонецОбласти

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел()
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = "Справочник.СоглашенияСПоставщиками.Форма.ФормаСписка";
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Справочники.СоглашенияСПоставщиками))
		И ПравоДоступа("Изменение", Метаданные.Справочники.СоглашенияСПоставщиками);
	
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА СоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.НеСогласовано)
	|				ТОГДА СоглашениеСПоставщиком.Ссылка
	|		КОНЕЦ) КАК СоглашенияСПоставщикамиНаСогласовании,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА СоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.НеСогласовано)
	|					И СоглашениеСПоставщиком.ДатаНачалаДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|					И СоглашениеСПоставщиком.ДатаНачалаДействия < &ДатаАктуальности
	|				ТОГДА СоглашениеСПоставщиком.Ссылка
	|			КОГДА СоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
	|					И СоглашениеСПоставщиком.ДатаОкончанияДействия <> ДАТАВРЕМЯ(1, 1, 1)
	|					И СоглашениеСПоставщиком.ДатаОкончанияДействия < &ДатаАктуальности
	|				ТОГДА СоглашениеСПоставщиком.Ссылка
	|			КОГДА СоглашениеСПоставщиком.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует)
	|					И СоглашениеСПоставщиком.ДатаНачалаДействия <> ДАТАВРЕМЯ(1,1,1) И
	|					СоглашениеСПоставщиком.ДатаНачалаДействия > &ДатаАктуальности
	|				ТОГДА СоглашениеСПоставщиком.Ссылка
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК СоглашенияСПоставщикамиПросроченные
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК СоглашениеСПоставщиком
	|ГДЕ
	|	СоглашениеСПоставщиком.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Закрыто)
	|	И СоглашениеСПоставщиком.Менеджер = &Пользователь
	|	И (НЕ СоглашениеСПоставщиком.ПометкаУдаления)";
	
	Результат = ТекущиеДелаСлужебный.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	// Заполнение дел.
	// СоглашенияСПоставщиками
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "СоглашенияСПоставщиками";
	ДелоРодитель.Представление  = НСтр("ru = 'Соглашения с поставщиками'");
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Закупки;
	
	// СоглашенияСПоставщикамиНаСогласовании
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Состояние", Перечисления.СостоянияСоглашенийСПоставщиками.ОжидаетсяСогласование);
	ПараметрыОтбора.Вставить("Актуальность", "");
	ПараметрыОтбора.Вставить("ДатаСобытия", ОбщиеПараметрыЗапросов.ПустаяДата);
	ПараметрыОтбора.Вставить("Менеджер", ОбщиеПараметрыЗапросов.Пользователь);
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "СоглашенияСПоставщикамиНаСогласовании";
	Дело.ЕстьДела       = Результат.СоглашенияСПоставщикамиНаСогласовании > 0;
	Дело.Представление  = НСтр("ru = 'Соглашения на согласовании'");
	Дело.Количество     = Результат.СоглашенияСПоставщикамиНаСогласовании;
	Дело.Важное         = Ложь;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = "СоглашенияСПоставщиками";
	
	// СоглашенияСПоставщикамиПросроченные
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Состояние", Неопределено);
	ПараметрыОтбора.Вставить("Актуальность", "Просроченные");
	ПараметрыОтбора.Вставить("ДатаСобытия", ОбщиеПараметрыЗапросов.ПустаяДата);
	ПараметрыОтбора.Вставить("Менеджер", ОбщиеПараметрыЗапросов.Пользователь);
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "СоглашенияСПоставщикамиПросроченные";
	Дело.ЕстьДела       = Результат.СоглашенияСПоставщикамиПросроченные > 0;
	Дело.Представление  = НСтр("ru = 'Просроченные соглашения'");
	Дело.Количество     = Результат.СоглашенияСПоставщикамиПросроченные;
	Дело.Важное         = Истина;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = "СоглашенияСПоставщиками";
	
	Если Результат.СоглашенияСПоставщикамиНаСогласовании > 0
		Или Результат.СоглашенияСПоставщикамиПросроченные > 0 Тогда
		ДелоРодитель.ЕстьДела = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления УП 2.2.1,
// заполняет реквизит "Валюта взаиморасчетов" справочника "СоглашенияСПоставщиками".
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	СоглашенияСПоставщиками.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК СоглашенияСПоставщиками
	|ГДЕ 
	|	СоглашенияСПоставщиками.ВалютаВзаиморасчетов = Значение(Справочник.Валюты.ПустаяСсылка)");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.СоглашенияСПоставщиками";
	
	МетаданныеСправочника = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			НачатьТранзакцию();
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось заблокировать : %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
									УровеньЖурналаРегистрации.Предупреждение,
									МетаданныеСправочника,
									Выборка.Ссылка,
									ТекстСообщения);
			Продолжить;
			
		КонецПопытки;
		
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Если СправочникОбъект = Неопределено Тогда
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			ЗафиксироватьТранзакцию();
			Продолжить;
		КонецЕсли;
		
		ОбъектИзменен = Ложь;
		
		Если НЕ ЗначениеЗаполнено(СправочникОбъект.ВалютаВзаиморасчетов) Тогда
			СправочникОбъект.ВалютаВзаиморасчетов = СправочникОбъект.Валюта;
			ОбъектИзменен = Истина;
		КонецЕсли;
		
		Попытка
			
			Если ОбъектИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект, Истина);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			КонецЕсли;
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать : %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеСправочника,
				Выборка.Ссылка,
				ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

// Обработчик обновления УП 2.2.3,
// создает документы "СоглашенияСПоставщиками".
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию2(Параметры) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	СоглашенияСПоставщиками.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК СоглашенияСПоставщиками
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.СоглашениеСПоставщиком КАК ТаблицаДокумента
	|	ПО ТаблицаДокумента.Соглашение = СоглашенияСПоставщиками.Ссылка
	|ГДЕ
	|	ТаблицаДокумента.Ссылка ЕСТЬ NULL
	|	И СоглашенияСПоставщиками.ВариантПриемкиТоваров В (
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным),
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.МожетПроисходитьБезЗаказовИНакладных),
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.НеРазделенаПоНакладным)
	|		)
	|");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию2(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.СоглашенияСПоставщиками";
	
	МетаданныеСправочника = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СсылкиДляОбработки.Ссылка КАК Ссылка,
	|	ИСТИНА КАК ТребуетсяСоздатьДокумент
	|ПОМЕСТИТЬ ВТСсылкиСПризнаками
	|ИЗ
	|	&ВТДляОбработкиСсылка КАК СсылкиДляОбработки
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.СоглашениеСПоставщиком КАК ТаблицаДокумента
	|	ПО ТаблицаДокумента.Соглашение = СсылкиДляОбработки.Ссылка
	|ГДЕ
	|	ТаблицаДокумента.Ссылка ЕСТЬ NULL
	|	И СсылкиДляОбработки.Ссылка.ВариантПриемкиТоваров В (
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным),
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.МожетПроисходитьБезЗаказовИНакладных),
	|		ЗНАЧЕНИЕ(Перечисление.ВариантыПриемкиТоваров.НеРазделенаПоНакладным)
	|		)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СсылкиДляОбработки.Ссылка КАК Ссылка,
	|	ЛОЖЬ КАК ТребуетсяСоздатьДокумент
	|ИЗ
	|	&ВТДляОбработкиСсылка КАК СсылкиДляОбработки
	|
	|;
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СсылкиДляОбработки.Ссылка КАК Ссылка,
	|	МАКСИМУМ(СсылкиДляОбработки.ТребуетсяСоздатьДокумент) КАК ТребуетсяСоздатьДокумент
	|ИЗ
	|	ВТСсылкиСПризнаками КАК СсылкиДляОбработки
	|СГРУППИРОВАТЬ ПО
	|	СсылкиДляОбработки.Ссылка";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВТДляОбработкиСсылка", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			НачатьТранзакцию();
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось заблокировать : %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
									УровеньЖурналаРегистрации.Предупреждение,
									МетаданныеСправочника,
									Выборка.Ссылка,
									ТекстСообщения);
			Продолжить;
			
		КонецПопытки;
		
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Если СправочникОбъект = Неопределено Тогда
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			ЗафиксироватьТранзакцию();
			Продолжить;
		КонецЕсли;
		
		Попытка
		
			Если Выборка.ТребуетсяСоздатьДокумент Тогда
				
				ДокументСуществует = ПолучитьДокументРегистрации(Выборка.Ссылка);
				
				Если Не ЗначениеЗаполнено(ДокументСуществует) Тогда
					
					СоглашениеСПоставщиком = Документы.СоглашениеСПоставщиком.СоздатьДокумент();
					СоглашениеСПоставщиком.Дата       = ТекущаяДата();
					СоглашениеСПоставщиком.Соглашение = Выборка.Ссылка;
					ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СоглашениеСПоставщиком, Истина);
					
				КонецЕсли;
				
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать : %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеСправочника,
				Выборка.Ссылка,
				ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ШаблоныСообщений

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения
//         ** Имя            - Строка - Уникальное имя вложения.
//         ** Представление  - Строка - Представление варианта.
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl" и др.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщений.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура - структура с ключами:
//    * ЗначенияРеквизитов - Соответствие - список используемых в шаблоне реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие - список используемых в шаблоне общих реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие - значения реквизитов 
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище вложения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ДополнительныеПараметры - Структура -  Дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, ПредметСообщения, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Заполняет список получателей SMS при отправке сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиSMS - ТаблицаЗначений - список получается SMS.
//     * НомерТелефона - Строка - номер телефона, куда будет отправлено сообщение SMS.
//     * Представление - Строка - представление получателя сообщения SMS.
//     * Контакт       - СправочникСсылка - контакт, которому принадлежит номер телефона.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//
Процедура ПриЗаполненииТелефоновПолучателейВСообщении(ПолучателиSMS, ПредметСообщения) Экспорт
	
КонецПроцедуры

// Заполняет список получателей письма при отправки сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма.
//     * Адрес           - Строка - адрес электронной почты получателя.
//     * Представление   - Строка - представление получается письма.
//     * ВариантОтправки - Строка - Варианты отправки письма: "Кому", "Копия", "СкрытаяКопия", "ОбратныйАдреса";
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, ПредметСообщения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#КонецЕсли
