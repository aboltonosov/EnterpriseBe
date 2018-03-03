﻿
////////////////////////////////////////////////////////////////////////////////
// ОбменСКонтрагентамиКлиентПереопределяемый: механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму выбора пользователей информационной базы.
//
// Параметры:
//  ЭтотОбъект - Объект - владелец формы;
//  ТекущийПользователь - СправочникСсылка.Пользователи - ссылка на текущего пользователя в справочнике "Пользователи".
//
Процедура ОткрытьФормуВыбораПользователей(ЭтаФорма, ТекущийПользователь) Экспорт
	
	Параметры = Новый Структура("Ключ", ТекущийПользователь);
	Параметры.Вставить("РежимВыбора",             Истина);
	Параметры.Вставить("ТекущаяСтрока",           ТекущийПользователь);
	Параметры.Вставить("ВыборГруппПользователей", Ложь);
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", Параметры, ЭтаФорма);
	
КонецПроцедуры

// Проверяет на модифицированность объект в случае обычного приложения.
//
// Параметры:
//  Объект - ДокументОбъект - Основной реквизит формы, модифицированность которого надо проверить;
//  Форма - Форма - форма объекта, модифицированность которого надо проверить.
//  Результат - Булево - результат проверки модифицированности формы объекта.
//
Процедура ОбъектМодифицирован(Объект, Форма, Результат) Экспорт
	
КонецПроцедуры

// Проверка выполнения автоматических условий для подписи документа.
//
// Параметры:
//  ЭлектронныйДокумент - Ссылка - ссылка на присоединенный файл.
//
// Возвращаемое значение:
//  Булево - пройдена дополнительная проверка для подписания.
//
Функция ЭлектронныйДокументГотовКПодписи(ЭлектронныйДокумент) Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет адрес хранилища с таблицей значений - каталога товаров.
//
// Параметры:
//  ИдентификаторФормы - УникальныйИдентификатор - уникальный  идентификатор формы, вызвавшей функцию.
//  ОбработкаПродолжения - ОписаниеОповещения - содержит описание процедуры,
//                         которая будет вызвана после закрытия формы подбора.
//
Процедура ОткрытьФормуПодбораТоваров(ИдентификаторФормы, ОбработкаПродолжения) Экспорт
	
	
КонецПроцедуры

// Устарела. Следует использовать процедуру ОткрытьФормуПодбораТоваров.
// Заполняет адрес хранилища с таблицей значений - каталога товаров.
//
// Параметры:
//  АдресВоВременномХранилище - Строка - адрес хранения каталога товаров;
//  ИдентификаторФормы - УникальныйИдентификатор -уникальный  идентификатор формы, вызвавшей функцию.
//
Процедура ПоместитьКаталогТоваровВоВременноеХранилище(АдресВоВременномХранилище, ИдентификаторФормы) Экспорт
	
	ОбменСКонтрагентамиСлужебныйВызовСервера.ПоместитьКаталогТоваровВоВременноеХранилище(
													АдресВоВременномХранилище,
													ИдентификаторФормы);
	
КонецПроцедуры
	
// Устарела. Следует использовать процедуру ВыполнитьПроверкуПроведенияДокументов.
// Выполняет интерактивное проведение документов перед формированием ЭД.
// Если есть непроведенные документы, предлагает выполнить проведение.
// Спрашивает пользователя о продолжении, если какие-то из документов не провелись и имеются проведенные.
//
// Параметры:
//  ДокументыМассив - Массив - ссылки на документы, которые требуется провести перед печатью.
//                             После выполнения функции из массива исключаются непроведенные документы.
//  ДокументыПроведены - Булево - возвращаемый параметр, признак что документы проведены.
//  ФормаИсточник - УправляемаяФорма - форма, из которой было вызвана команда.
//
Процедура ПроверитьДокументыПроведены(ДокументыМассив, ДокументыПроведены, ФормаИсточник = Неопределено) Экспорт
	
КонецПроцедуры

// Проверяет на использование в прикладном решении библиотеки интернет поддержки пользователей.
//
// Параметры:
//  Использование - булево - признак использования библиотеки БИП.
//
Процедура ПроверитьИспользованиеИнтернетПоддержкаПользователей(Использование) Экспорт
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().РазделениеВключено Тогда
		Использование = Ложь;
	Иначе
		Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сопоставление номенклатуры

// В зависимости от прикладного решения определяет момент открытия формы сопоставления номенклатуры.
//
// Параметры:
//  СопоставлятьНоменклатуру - Булево - если Истина - открывать форму сопоставления до заполнения документа, Ложь - в обратном порядке.
//    Например, Истина для УПП, БП, Ложь для УТ.
//
Процедура СопоставлятьНоменклатуруПередЗаполнениемДокумента(СопоставлятьНоменклатуру) Экспорт
	
	СопоставлятьНоменклатуру = Ложь;
	
КонецПроцедуры

// Находит элемент номенклатуры поставщика и открывает форму просмотра.
//
// Параметры:
//  Идентификатор - УникальныйИдентификатор - уникальный идентификатор объекта.
//
Процедура ОткрытьЭлементНоменклатурыПоставщика(Идентификатор) Экспорт
	
	ДополнительныеРеквизиты = Новый Структура;
	ДополнительныеРеквизиты.Вставить("Идентификатор", Идентификатор);
	
	НоменклатураПоставщика = ОбменСКонтрагентамиСлужебныйВызовСервера.НайтиСсылкуНаОбъект("НоменклатураПоставщиков",
																						   ,
																						   ДополнительныеРеквизиты);
	Если ЗначениеЗаполнено(НоменклатураПоставщика) Тогда
		ПоказатьЗначение(, НоменклатураПоставщика);
	КонецЕсли;
	
КонецПроцедуры

// Предназначена для переопределения стандартной формы выбора номенклатуры в форме сопоставления номенклатуры.
//
// Параметры:
//  Элемент - ЭлементыФормы - элемент формы.
//  Параметры - Структура - параметры, содержит элемент "Контрагент".
//  СтандартнаяОбработка - Булево - необходимость отключать стандартную обработку при переопределении формы выбора.
//
Процедура ОткрытьФормуСопоставленияНоменклатуры(Элемент, Параметры, СтандартнаяОбработка = Неопределено) Экспорт
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Лицензионное соглашение

// Вспомогательная процедура для запуска механизма согласия пользователя с условиями лицензионного соглашения.
//
// Параметры:
//  СогласенСУсловиями - Булево - если возвращает Ложь, то пользователь не согласен с условиями.
//
Процедура ЗапроситьСогласиеСУсловиямиЛицензионногоСоглашения(СогласенСУсловиями) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

