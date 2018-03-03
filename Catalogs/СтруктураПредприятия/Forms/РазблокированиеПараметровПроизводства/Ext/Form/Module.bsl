﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация") Тогда
		
		Элементы.ПроизводствоБезЗаказаЗаголовок.Заголовок = НСтр("ru = 'Производство'");
		
		Элементы.ВариантСписанияЗатратНаВыпускиБезЗаказовЗаголовок.Заголовок =
			НСтр("ru = 'Вариант списания затрат на выпуск'");
		
	КонецЕсли;
	
	ЗаполнитьПроверяемыеПараметры();
	
	УправлениеВидимостью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)

	Результат = БлокируемыеРеквизитыОбъекта();
	Закрыть(Результат);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИспользованиеОбъекта(Команда)
	
	Результат = ПроверитьИспользованиеОбъектаНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала = 1.2; // Уменьшим шаг увеличения времени опроса выполнения задания
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		ПолучитьРезультатПроверкиНаСервере();
    КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

// Унифицированная процедура проверки выполнения фонового задания.
//
&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
 
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ПолучитьРезультатПроверкиНаСервере();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьИспользованиеОбъектаНаСервере()
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Объект", Параметры.Объект);
	
	Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	
	//++ НЕ УТ
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Справочники.СтруктураПредприятия.ПроверитьИспользованиеПараметровПроизводства(ПараметрыЗадания, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
		
	Иначе
		
		НаименованиеЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Проверка использования объекта %1'"),
				Параметры.Объект);
				
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
				УникальныйИдентификатор,
				"Справочники.СтруктураПредприятия.ПроверитьИспользованиеПараметровПроизводства",
				ПараметрыЗадания,
				НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
		
	КонецЕсли; 
	//-- НЕ УТ
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПолучитьРезультатПроверкиНаСервере()
	
	РезультатПроверки = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	ОбъектИспользуется = Ложь;
	
	//++ НЕ УТКА
	
	// Подразделение-диспетчер
	Если ПроверятьПодразделениеДиспетчер Тогда
		
		Элементы.ПодразделениеДиспетчерПроверкаНеВыполнена.Видимость = Ложь;
		Элементы.ПодразделениеДиспетчерПараметрНеИспользуется.Видимость = НЕ РезультатПроверки.ИспользуетсяКакДиспетчер;
		Элементы.ПодразделениеДиспетчерПараметрИспользуется.Видимость = РезультатПроверки.ИспользуетсяКакДиспетчер;
		Элементы.ПодразделениеДиспетчерПараметрИспользуетсяОписание.Видимость = РезультатПроверки.ИспользуетсяКакДиспетчер;
		
		ОбъектИспользуется = ?(РезультатПроверки.ИспользуетсяКакДиспетчер, Истина, ОбъектИспользуется);
		
	КонецЕсли;
	
	// Производство по заказу
	Если ПроверятьПроизводствоПоЗаказу Тогда
		
		Элементы.ПроизводствоПоЗаказуПроверкаНеВыполнена.Видимость = Ложь;
		Элементы.ПроизводствоПоЗаказуПараметрНеИспользуется.Видимость = НЕ РезультатПроверки.ИспользуетсяДляПроизводстваПоЗаказам;
		Элементы.ПроизводствоПоЗаказуПараметрИспользуется.Видимость = РезультатПроверки.ИспользуетсяДляПроизводстваПоЗаказам;
		Элементы.ПроизводствоПоЗаказуПараметрИспользуетсяОписание.Видимость = РезультатПроверки.ИспользуетсяДляПроизводстваПоЗаказам;
		
		ОбъектИспользуется = ?(РезультатПроверки.ИспользуетсяДляПроизводстваПоЗаказам, Истина, ОбъектИспользуется);
		
	КонецЕсли;
	
	// Интервал планирования
	Если ПроверятьИнтервалПланирования Тогда
		
		Элементы.ИнтервалПланированияПроверкаНеВыполнена.Видимость = Ложь;
		Элементы.ИнтервалПланированияПараметрНеИспользуется.Видимость = НЕ РезультатПроверки.ИнтервалПланированияИспользуется;
		Элементы.ИнтервалПланированияПараметрИспользуется.Видимость = РезультатПроверки.ИнтервалПланированияИспользуется;
		Элементы.ИнтервалПланированияПараметрИспользуетсяОписание.Видимость = РезультатПроверки.ИнтервалПланированияИспользуется;
		
		ОбъектИспользуется = ?(РезультатПроверки.ИнтервалПланированияИспользуется, Истина, ОбъектИспользуется);
		
	КонецЕсли;
	
	// Управление маршрутными листами
	Если ПроверятьУправлениеМаршрутнымиЛистами Тогда
		
		Элементы.УправлениеМаршрутнымиЛистамиПроверкаНеВыполнена.Видимость = Ложь;
		Элементы.УправлениеМаршрутнымиЛистамиПараметрНеИспользуется.Видимость = НЕ РезультатПроверки.УправлениеМаршрутнымиЛистамиИспользуется;
		Элементы.УправлениеМаршрутнымиЛистамиПараметрИспользуется.Видимость = РезультатПроверки.УправлениеМаршрутнымиЛистамиИспользуется;
		Элементы.УправлениеМаршрутнымиЛистамиПараметрИспользуетсяОписание.Видимость = РезультатПроверки.УправлениеМаршрутнымиЛистамиИспользуется;
		
		ОбъектИспользуется = ?(РезультатПроверки.УправлениеМаршрутнымиЛистамиИспользуется, Истина, ОбъектИспользуется);
		
	КонецЕсли;
	
	// Способ управления операциями
	Если ПроверятьСпособУправленияОперациями Тогда
		
		Элементы.СпособУправленияОперациямиПроверкаНеВыполнена.Видимость = Ложь;
		Элементы.СпособУправленияОперациямиПараметрНеИспользуется.Видимость = НЕ РезультатПроверки.ПооперационноеРасписаниеИспользуется;
		Элементы.СпособУправленияОперациямиПараметрИспользуется.Видимость = РезультатПроверки.ПооперационноеРасписаниеИспользуется;
		Элементы.СпособУправленияОперациямиПараметрИспользуетсяОписание.Видимость = РезультатПроверки.ПооперационноеРасписаниеИспользуется;
		
		ОбъектИспользуется = ?(РезультатПроверки.ПооперационноеРасписаниеИспользуется, Истина, ОбъектИспользуется);
		
	КонецЕсли;
	
	// Пооперационное управление этапами
	Если ПроверятьПооперационноеУправлениеЭтапами Тогда
		
		Элементы.ПооперационноеУправлениеЭтапамиПроверкаНеВыполнена.Видимость = Ложь;
		Элементы.ПооперационноеУправлениеЭтапамиПараметрНеИспользуется.Видимость = НЕ РезультатПроверки.ИспользуетсяПооперационноеУправлениеЭтапами;
		Элементы.ПооперационноеУправлениеЭтапамиПараметрИспользуется.Видимость = РезультатПроверки.ИспользуетсяПооперационноеУправлениеЭтапами;
		Элементы.ПооперационноеУправлениеЭтапамиПараметрИспользуетсяОписание.Видимость = РезультатПроверки.ИспользуетсяПооперационноеУправлениеЭтапами;
		
		ОбъектИспользуется = ?(РезультатПроверки.ИспользуетсяПооперационноеУправлениеЭтапами, Истина, ОбъектИспользуется);
		
	КонецЕсли;
	
	//-- НЕ УТКА
	
	// Производство без заказов
	Если ПроверятьПроизводствоБезЗаказа Тогда
		
		Элементы.ПроизводствоБезЗаказаПроверкаНеВыполнена.Видимость = Ложь;
		
		Элементы.ПроизводствоБезЗаказаПараметрНеИспользуется.Видимость =
			НЕ РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		Элементы.ПроизводствоБезЗаказаПараметрИспользуется.Видимость =
			РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		Элементы.ПроизводствоБезЗаказаПараметрИспользуетсяОписание.Видимость =
			РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		ОбъектИспользуется = ?(РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов, Истина, ОбъектИспользуется);
		
	КонецЕсли;
	
	// Вариант списания затрат на выпуски без заказов
	Если ПроверятьВариантСписанияЗатратНаВыпускиБезЗаказов Тогда
		
		Элементы.ВариантСписанияЗатратНаВыпускиБезЗаказовПроверкаНеВыполнена.Видимость = Ложь;
		
		Элементы.ВариантСписанияЗатратНаВыпускиБезЗаказовПараметрНеИспользуется.Видимость =
			НЕ РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		Элементы.ВариантСписанияЗатратНаВыпускиБезЗаказовПараметрИспользуется.Видимость =
			РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		Элементы.ВариантСписанияЗатратНаВыпускиБезЗаказовПараметрИспользуетсяОписание.Видимость =
			РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		ОбъектИспользуется = ?(РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов, Истина, ОбъектИспользуется);
		
	КонецЕсли;
	
	// Результат проверки
	Если ОбъектИспользуется Тогда
		Элементы.ГруппаОбъектИспользуетсяСтраницы.ТекущаяСтраница = Элементы.ГруппаОбъектИспользуетсяОбъектИспользуется;
	Иначе
		Элементы.ГруппаОбъектИспользуетсяСтраницы.ТекущаяСтраница = Элементы.ГруппаОбъектИспользуетсяОбъектНеИспользуется;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция БлокируемыеРеквизитыОбъекта()
	
	Реквизиты = Справочники.СтруктураПредприятия.ПолучитьБлокируемыеРеквизитыОбъекта();
	
	Индекс = 0;
	Для каждого Реквизит Из Реквизиты Цикл
		
		СимволРазделитель = СтрНайти(Реквизит, ";");
		Если НЕ СимволРазделитель = 0 Тогда
			Реквизиты[Индекс] = СокрЛП(Лев(Реквизит, СимволРазделитель-1));
		КонецЕсли;
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	Возврат Реквизиты;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПроверяемыеПараметры()
	
	ЭтоКА = ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация");
	
	ПроверятьПодразделениеДиспетчер = Не ЭтоКА;
	ПроверятьПроизводствоПоЗаказу = Не ЭтоКА;
	ПроверятьИнтервалПланирования = Не ЭтоКА;
	
	//++ НЕ УТ
	
	НастройкиПодсистемыПроизводство = ПроизводствоСервер.НастройкиПодсистемыПроизводство();
	Производство21 = НастройкиПодсистемыПроизводство.ИспользуетсяПроизводство21;
	Производство22 = НастройкиПодсистемыПроизводство.ИспользуетсяПроизводство22;
	
	ПроверятьУправлениеМаршрутнымиЛистами = Производство21;
	ПроверятьСпособУправленияОперациями = Производство21;
	ПроверятьПроизводствоБезЗаказа = Производство21;
	ПроверятьВариантСписанияЗатратНаВыпускиБезЗаказов = Производство21;
	ПроверятьПооперационноеУправлениеЭтапами = Производство22;
	
	//-- НЕ УТ
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостью()
	
	Элементы.ГруппаПодразделениеДиспетчер.Видимость = ПроверятьПодразделениеДиспетчер;
	Элементы.ГруппаПроизводствоПоЗаказу.Видимость = ПроверятьПроизводствоПоЗаказу;
	Элементы.ГруппаИнтервалПланирования.Видимость = ПроверятьИнтервалПланирования;
	Элементы.ГруппаУправлениеМаршрутнымиЛистами.Видимость = ПроверятьУправлениеМаршрутнымиЛистами;
	Элементы.ГруппаСпособУправленияОперациями.Видимость = ПроверятьСпособУправленияОперациями;
	Элементы.ГруппаПроизводствоБезЗаказа.Видимость = ПроверятьПроизводствоБезЗаказа;
	Элементы.ГруппаВариантСписанияЗатратНаВыпускиБезЗаказов.Видимость = ПроверятьВариантСписанияЗатратНаВыпускиБезЗаказов;
	Элементы.ГруппаПооперационноеУправлениеЭтапами.Видимость = ПроверятьПооперационноеУправлениеЭтапами;
	
КонецПроцедуры

#КонецОбласти
